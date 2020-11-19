module ReferencesHelper
  include YamlHelpers

  def get_references
    data = load_yaml("lib/data/content/shared.yml")

    {
      title: "References",
      text: data['references']
    }.to_json
  end
end