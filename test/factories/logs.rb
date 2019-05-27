FactoryBot.define do
  factory :log, class: AuditLog::Log do
    association :user, factory: :user
    association :record, factory: :topic
    action { 'create_topic' }
  end
end
