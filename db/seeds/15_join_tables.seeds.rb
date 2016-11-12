roles = Role.count
topics = Topic.count

values = []
columns = [:role_id, :user_id]
(roles * USERS / 3.1415).round.times do
  values << [
    number(1, roles),
    number(1, USERS)
  ]
end
values.uniq!
RoleUser.import columns, values, validate: false, batch_size: BATCH_SIZE
print "RoleUser: #{completed(values.size)}"

values = []
columns = [:talk_id, :user_id]
TALKS.times do
  n = number(1, TALKS)
  values << [
    n,
    number(1, USERS)
  ]
  if low_chance # low chance that talk has multiple presenters
    number(1, 4).times do
      values << [
        n,
        number(1, USERS)
      ]
    end
  end
end
values.uniq!
TalkUser.import columns, values, validate: false, batch_size: BATCH_SIZE
print "TalkUser: #{completed(values.size)}"

values = []
columns = [:topic_id, :user_id]
USERS.times do |user|
  if low_chance # low chance that user is an expert on some topic
    values << [
      number(1, topics),
      user + 1
    ]
    if normal_chance # but normal chance that is expert on some other(s) topics
      number(1, 4).times do
        values << [
          number(1, topics),
          user + 1
        ]
      end
    end
  end
end
values.uniq!
TopicUser.import columns, values, validate: false, batch_size: BATCH_SIZE
print "TopicUser: #{completed(values.size)}"

values = []
columns = [:conference_id, :topic_id]
CONFERENCES.times do |conference|
  number(1, (topics/2).round).times do |topic|
    values << [
      conference + 1,
      topic + 1
    ]
  end
end
values.uniq!
ConferenceTopic.import columns, values, validate: false, batch_size: BATCH_SIZE
print "ConferenceTopic: #{completed(values.size)}"
