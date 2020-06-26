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
      word = word.strip.gsub(%r{[^\p{Han}+/ua-zA-Z0-9]}, '')
      word.chars.inject(self.words) do |words, char|
        if !words.key? char
          words[char] = {}
        end
        words[char]
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
      sensitive_word = ''
      word = word.strip.gsub(%r{[^\p{Han}+/ua-zA-Z0-9]}, '')
      word.chars.each_with_index.inject(self.words) do |words, (char, index)|
        if words.key?(char)
          sensitive_word += char
          break if words[char].empty?
          # 如果被检测的词已是最后一个，但关键字还不是最后，则返为空
          return '' if index == word.size - 1
          words[char]
        else
          # 如果上一步在关键字中，这次又不在关键字中，需要重新初始化检测
          if !sensitive_word.empty?
            sensitive_word = ''
            words = self.words and redo
          else
            words
          end
        end
      end
      sensitive_word
    end
  end
end

