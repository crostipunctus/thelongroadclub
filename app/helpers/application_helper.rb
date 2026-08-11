module ApplicationHelper
  def compact_number(number)
    if number >= 1_000_000
      "#{(number / 1_000_000.0).round(1)}m"
    elsif number >= 1_000
      "#{(number / 1_000.0).round(1)}k"
    else
      number.to_s
    end
  end

  def flash_class(type)
    type.to_sym == :alert ? "flash--alert" : "flash--notice"
  end
end
