module YamlHelpers
  def load_yaml(file_path, values=nil)
    data = YAML.load(File.open("#{Rails.root}/#{file_path}", 'r'))

    if values.present? 
      data.each do |key, value|
        data[key] = yaml_str_replace(value, values)
      end
    end

    data
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
    value = hash[key]

    if value.nil? then
      raise "The key '#{key}' does not exist in the given values hash when loading yaml content."
    else
      return value
    end
  end
end