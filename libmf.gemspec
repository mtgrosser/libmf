require_relative "lib/libmf/version"

Gem::Specification.new do |spec|
  spec.name          = "libmf"
  spec.version       = Libmf::VERSION
  spec.summary       = "Large-scale sparse matrix factorization for Ruby"
  spec.homepage      = "https://github.com/ankane/libmf"
  spec.license       = "BSD-3-Clause"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,ext}/**/*"]
  spec.require_paths = %w[lib ext]
  spec.extensions    = %w[ext/libmf/extconf.rb]

  spec.required_ruby_version = ">= 2.4"

  spec.add_dependency "ffi"
  spec.add_dependency "rake"
end
