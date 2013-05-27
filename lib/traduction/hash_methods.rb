module Traduction
  module HashMethods

    def flatten_keys(prefix = [], options = {})
      join_char = options[:join] || '.'
      prefix_keys = prefix.is_a?(Array) ? prefix : [prefix]

      ret = {}

      self.each_pair do |key, value|
        sub_prefix = prefix_keys + [key.to_s]
        case value
        when Hash
          ret.merge!(value.flatten_keys(sub_prefix))
        else
          ret[sub_prefix.join('.')] = value
        end
      end

      ret
    end

    def diff_more(other_hash, options = {})
      ignore_values = options[:ignore_values] || false

      diff_hash = {}

      self.each_pair do |key, value|
        case value
        when Hash
          sub_tree_hash = other_hash.include?(key) ? value.diff_more(other_hash[key]) : value
          diff_hash[key] = sub_tree_hash unless sub_tree_hash.empty?
        else
          diff_hash[key] = value unless other_hash.include?(key) && (!ignore_values || other_hash[key] == value)
        end
      end

      diff_hash
    end

  end
end
