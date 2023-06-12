defmodule Orcasite.Notifications.NotificationInstance do
  use Ash.Resource,
    extensions: [AshAdmin.Resource],
    data_layer: Ash.DataLayer.Ets

  alias Orcasite.Notifications.Changes.ExtractNotificationInstanceMeta
  alias Orcasite.Notifications.{Notification, Subscription}

  resource do
    description """
    Sends a single notification to a subscription
    """
  end

  code_interface do
    define_for Orcasite.Notifications
    define :update, action: :update, args: [:status, :meta, :processed_at]
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :create_with_relationships do
      accept [:subscription, :notification]

      argument :subscription, :uuid
      argument :notification, :uuid

      change manage_relationship(:subscription, type: :append)
      change manage_relationship(:notification, type: :append)

      change {ExtractNotificationInstanceMeta, []}

      change fn changeset, _context ->
        changeset
        |> Ash.Changeset.after_action(fn _, record ->
          record
          |> Orcasite.Notifications.Sending.queue()

          {:ok, record}
        end)
      end
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :meta, :map

    attribute :channel, :atom do
      constraints one_of: [:email]
    end

    attribute :processed_at, :utc_datetime_usec

    attribute :status, :atom do
      constraints one_of: [:new, :pending, :sent, :failed]
      default :new
    end

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :subscription, Subscription
    belongs_to :notification, Notification
  end
end