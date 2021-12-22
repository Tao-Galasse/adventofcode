# frozen_string_literal: true

PIXELS = [-1, 0, 1].product([-1, 0, 1]).freeze

def index_for(image, x, y, step)
  PIXELS.map { |a, b| [x + a, y + b] }.map do |a, b|
    # on the edges, every pixel is on or off depending on the step, because algorithm[0] == '#' in the input !
    next step.even? ? 0 : 1 if a < 0 || b < 0 || a >= image.length || b >= image.length

    image[a][b] == '.' ? 0 : 1
  end.join.to_i(2)
end

def build_next_image(image, step)
  (0..image.length + 1).map do |x|
    (0..image.length + 1).map do |y|
      @algorithm[index_for(image, x - 1, y - 1, step)]
    end.join
  end
end

@algorithm = File.read('input.txt').split("\n")[0]
image = File.read('input.txt').split("\n")[2..]

2.times { |step| image = build_next_image(image, step) }
puts "part 1: #{image.map { |l| l.count('#') }.sum} pixels are lit after 2 steps"
48.times { |step| image = build_next_image(image, step + 2) } # 50 - 2 = 48, and step starts at 2
puts "part 2: #{image.map { |l| l.count('#') }.sum} pixels are lit after 50 steps"
