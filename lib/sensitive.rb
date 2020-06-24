# frozen_string_literal: true

require "sensitive/version"

module Sensitive
  class Error < StandardError; end

  @words = {}

  class << Sensitive
    # attr_accessor defines reader methods for an instance. 
    attr_accessor :words

    # 添加单个敏感词
    def add_word(word)
      temp = words
      # 去掉敏感词中的特殊符号，只保留汉字，英文和 数字
      word = word.strip.gsub(%r{[^\p{Han}+/ua-zA-Z0-9]}, '')
      word.chars.each_with_index do |char, index|
        if temp.key?(char)
          temp = temp[char][:value]
        elsif index == word.chars.size - 1
          temp[char] = { is_end: true, value: {} }
        else
          temp[char] = { is_end: false, value: {} }
          temp = temp[char][:value]
        end
      end
    end

    # 清空整个敏感词hash
    def empty!
      self.words = {}
    end
    
    # 从用户文件中导入敏感词
    def load_file(file_path)
      File.open(file_path, 'r').each_line do |line|
        add_word(line)
      end
    end

    # 导入Gem自带敏感词
    def load_default
      load_file(File.join( File.dirname(__FILE__), '../sensitives.txt' ))
    end

    # 过滤敏感词
    def filter(word)
      # matched_one 判断某个字是否被关键字命中过
      matched_one = false
      sensitive_word = ''
      temp = words.clone
      word = word.strip.gsub(%r{[^\p{Han}+/ua-zA-Z0-9]}, '')
      word.chars.each do |char|
        if temp.key? char
          matched_one = true
          sensitive_word += char
          break if temp[char][:is_end]
          temp = temp[char][:value]
        else
          sensitive_word = ''
          # 如果上一步在关键字中，这次又不在关键字中，需要重新初始化检测
          if matched_one
            matched_one = false
            temp = words.clone
            redo
          end
        end
      end
      sensitive_word
    end
  end

end
