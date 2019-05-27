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

## Usage

Use in controllers:

```rb
class TicktsController < ApplicationController
  def index
    audit! :tickets, user: current_user
  end

  def update
    audit! :update_ticket, payload: ticket_params
  end

  def destroy
    audit! :delete_ticket, user: current_user
  end

  private
    def ticket_params
      params.required(:ticket).permit!(:title, :description, :status)
    end
end
```

In models or other places:

```rb
AuditLog.audit(:update_password, payload: { ip: request.ip })
AuditLog.audit(:sign_in, payload: { ip: request.ip })
AuditLog.audit(:create_address, payload: params)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
