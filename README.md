# AuditLog

Trail audit logs (Operation logs) into the database for user behaviors, including a web UI to query logs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'audit-log'
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
    audit! :tickets, nil
  end

  def update
    audit! :update_ticket, @ticket, payload: ticket_params
  end

  def destroy
    audit! :delete_ticket
  end

  private

    def ticket_params
      params.required(:ticket).permit!(:title, :description, :status)
    end
end
```

In models or other places:

```rb
AuditLog.audit!(:update_password, @user, payload: { ip: request.ip })
AuditLog.audit!(:sign_in, @user, payload: { ip: request.ip })
AuditLog.audit!(:create_address, nil, payload: params)
```

Change `config/routes.rb` to add Route:

```rb
Rails.application.routes.draw do
  authenticate :user, -> (u) { u.admin? } do
    mount AuditLog::Engine => '/audit-log'
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
