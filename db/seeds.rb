# frozen_string_literal: true

$stdout.sync = true

email = ENV['ADMIN_EMAIL']
password = ENV['ADMIN_PASSWORD']

puts "=== Running seeds ==="
puts "ADMIN_EMAIL present: #{email.present?}"
puts "ADMIN_PASSWORD present: #{password.present?}"

if email.present? && password.present?
  admin = Admin.find_or_initialize_by(email: email)
  admin.password = password

  if admin.save
    puts "=== Admin saved successfully: #{email} (id: #{admin.id}) ==="
  else
    puts "=== Admin save FAILED: #{admin.errors.full_messages.join(', ')} ==="
  end
else
  puts "=== Skipping: ADMIN_EMAIL or ADMIN_PASSWORD not set ==="
end
