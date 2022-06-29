# AuditLog

Trail audit logs (Operation logs) into the database for user behaviors, including a Web UI to query logs.

[![Build Status](https://travis-ci.org/rails-engine/audit-log.svg?branch=master)](https://travis-ci.org/rails-engine/audit-log)

> We used audit-log in our production environment more than 1 year, until now (2020.5.21), it's inserted about **20 million** log in our system.

[中文介绍与使用说明](https://ruby-china.org/topics/39890)

## Demo UI

Audit log list:

<img width="870" src="https://user-images.githubusercontent.com/5518/58676735-e9570d80-838b-11e9-8ac0-6c5145b7fbb0.png">

Detail page:

<img width="870" src="https://user-images.githubusercontent.com/5518/58676737-e9570d80-838b-11e9-9292-63389b2d54cb.png">


## Installation

Add this line to your application's Gemfile:

```ruby
gem "audit-log"
```

And then execute:
```bash
$ bundle
```

Generate files:

```bash
$ rails g audit_log:install
```

## Usage

Use in controllers:

```rb
class TicktsController < ApplicationController
  def index
    audit! :list_ticket, nil
  end

  def create
    if @ticket.save
      audit! :create_ticket, @ticket, payload: ticket_params
    else
      render :new
    end
  end

  def update
    if @ticket.save
      audit! :update_ticket, @ticket, payload: ticket_params
    else
      render :edit
    end
  end

  def approve
    if @ticket.approve
      audit! :approve_ticket, @ticket, payload: ticket_params
    end
  end

  def destroy
    # store original attributes for destroy for keep values
    audit! :delete_ticket, nil, @ticket.attributes
  end

  private

    def ticket_params
      params.required(:ticket).permit!(:title, :description, :status)
    end
end
```

In models or other places:

```rb
AuditLog.audit!(:update_password, @user, payload: { ip: request.remote_ip })
AuditLog.audit!(:sign_in, @user, payload: { ip: request.remote_ip })
AuditLog.audit!(:create_address, nil, payload: params)
```

Change `config/routes.rb` to add Route:

```rb
Rails.application.routes.draw do
  authenticate :user, -> (u) { u.admin? } do
    mount AuditLog::Engine => "/audit-log"
  end
end
```

I18n for audit names, you need create a `config/locales/audit-log.zh-CN.yml`:

```yml
zh-CN:
  audit_log:
    action:
      sign_in: 登录
      update_password: 修改密码
      create_address: 添加住址
      list_ticket: 查看工单列表
      create_ticket: 创建工单
      update_ticket: 更新工单
      delete_ticket: 删除工单
      approve_ticket: 审批工单
```

For track Warden (Devise) sign in behavirs:

config/initializes/devise.rb

```rb
Warden::Manager.after_authentication do |user, auth, opts|
  request = ActionDispatch::Request.new(auth.env)
  AuditLog.audit!(:sign_in, user, payload: opts, user: user, request: request)
end

Warden::Manager.before_failure do |env, opts|
  request = ActionDispatch::Request.new(env)
  email = request.params.dig(:user, :email)
  user = User.find_by_email(email)
  opts[:email] = email
  AuditLog.audit!(:sign_in_failure, nil, payload: opts, request: request, user: user)
end
```

## Configuration

You can write a `config/initializers/audit_log.rb` to configure the behavior of audit log.

```rb
AuditLog.configure do
  # class name of you User model, default: 'User'
  self.user_class = "User"
  # current_user method name in your Controller, default: 'current_user'
  self.current_user_method = "current_user"
  # Speical a table_name for AuditLog model, default: "audit_logs"
  self.table_name = "audit_logs"
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
