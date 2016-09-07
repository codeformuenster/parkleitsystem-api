module DetailsParser
  def self.translate_key(key_name)
    translations = {
      "Preise" => "prices",
      "Öffnungszeiten" => "opening_times",
      "Behindertenparkplätze" => "disabled_parking",
      "Behinderten-WC" => "disabled_wc",
      "Betreiber" => "operator",
      "Einfahrtshöhe" => "entrance_height"
    }

    return translations[key_name] if translations[key_name]
    key_name
  end

  def self.parse_details(key, value)
    if value == "Ja"
      return true
    elsif value == "Nein"
      return false
    elsif key == "entrance_height"
      return calc_centimeters value
    end

    value
  end

  def self.parseTime(value)
    times = value.scan /\d - \d/
    weekmap = {
      monday: "",
      tuesday: "",
      wednesday: "",
      thursday: "",
      friday: "",
      saturday: "",
      sunday: ""
    }

    weekmap.each do |key, value|

    end
  end

  def self.calc_centimeters(height_string)
    height_string.match(/\d,\d*/).to_s.gsub(/,/, '').to_f
  end
end
