SecureUrl::SITE_KEY = '<%= Digest::SHA1.hexdigest([Date.today.to_s, rand].join("---")) -%>'
SecureUrl::HASH_ITERATIONS = 3