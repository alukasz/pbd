module Support
  def notify(filename)
    print "Seeding: #{filename}... "
  end

  def completed(records)
    puts "#{records} records inserted"
  end

  def high_chance(first_expr = true, second_expr = nil)
    chance(0.8, first_expr, second_expr)
  end

  def low_chance(first_expr = true, second_expr = nil)
    chance(0.2, first_expr, second_expr)
  end

  def normal_chance(first_expr = true, second_expr = nil)
    chance(0.5, first_expr, second_expr)
  end

  def very_high_chance(first_expr = true, second_expr = nil)
    chance(0.95, first_expr, second_expr)
  end

  def chance(chance, first_expr, second_expr)
    rand < chance ? first_expr : second_expr
  end

  def id_for(limit)
    rand(1..limit)
  end

  def number(range)
    rand(range)
  end

  def number(from, to)
    rand(from..to)
  end

  def currency
    [
      "USD",
      "EUR",
      "PLN",
      "USD",
      "EUR",
      "SCH",
      "USD",
      "EUR",
      "YEN",
      "USD",
      "EUR",
      "CDN"
    ].sample
  end
end
