module RandomNumberHelper
  def random_number
    rand(1000..9999).to_s
  end
end