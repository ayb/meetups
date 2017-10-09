%w(Organizer Presenter Participant).each do |name|
  Role.create(name: name)
end