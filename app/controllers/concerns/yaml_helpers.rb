module YamlHelpers
  # load_yaml will load a yaml file and cycle through the content looking for
  # any strings that contain the syntax `${something}`. If this is found then
  # values[something] is used to replace `${something}` in the yaml string.

  def load_yaml(file_path, values=nil)
    data = YAML.load(File.open("#{Rails.root}/#{file_path}", 'r'))

    yaml_object_replace(data, values)
  end

  def yaml_object_replace(value, replace_values)
    if value.is_a? Array
      yaml_array_replace(value, replace_values)
    elsif value.is_a? Hash
      yaml_hash_replace(value, replace_values)
    elsif value.is_a? String
      yaml_str_replace(value, replace_values)
    else
      value
    end
  end

  def yaml_array_replace(array, replace_values)
    array.map do |array_item|
      yaml_object_replace(array_item, replace_values)
    end
  end

  def yaml_hash_replace(hash, replace_values)
    new_hash = {}

    hash.each do |key, value|
      new_hash[key] = yaml_object_replace(value, replace_values)
    end

    new_hash
  end

  def yaml_str_replace(str, values)
    str.gsub(/\${([^}]*)}/) do
      begin
        value = get_value(values, $1)
      rescue => e
        logger.error e
      end

      value ? value : $1 
    end
  end

  def get_value(hash, key)
    if hash.nil? 
      raise "The placeholder '${#{key}}' can not be replaced in the yaml content as no values hash is provided."
    end
    
    value = hash[key]

    if value.nil?
      raise "The key '#{key}' does not exist in the given values hash when loading yaml content."
    else
      return value
    end
  end
end