every 12.hours do
  rake 'db:backup'
end

every 1.week do
  rake 'db:cleanup'
end

