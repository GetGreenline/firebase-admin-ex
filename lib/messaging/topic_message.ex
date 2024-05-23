defmodule FirebaseAdminEx.Messaging.TopicMessage do
  @moduledoc """
  This module is responsible for representing the
  attributes of FirebaseAdminEx.Message.
  """

  alias __MODULE__
  alias FirebaseAdminEx.Messaging.WebMessage.Config, as: WebMessageConfig
  alias FirebaseAdminEx.Messaging.AndroidMessage.Config, as: AndroidMessageConfig
  alias FirebaseAdminEx.Messaging.APNSMessage.Config, as: APNSMessageConfig

  @keys [
    data: %{},
    notification: %{},
    webpush: nil,
    android: nil,
    apns: nil,
    topic: ""
  ]

  @type t :: %__MODULE__{
          data: map(),
          notification: map(),
          webpush: struct(),
          android: struct(),
          apns: struct(),
          topic: String.t()
        }

  @derive Jason.Encoder
  defstruct @keys

  # Public API
  def new(%{topic: topic, webpush: webpush} = attributes) do
    %TopicMessage{
      data: Map.get(attributes, :data, %{}),
      notification: Map.get(attributes, :notification, %{}),
      webpush: webpush,
      topic: topic
    }
  end

  def new(%{topic: topic, android: android} = attributes) do
    %TopicMessage{
      data: Map.get(attributes, :data, %{}),
      notification: Map.get(attributes, :notification, %{}),
      android: android,
      topic: topic
    }
  end

  def new(%{topic: topic, apns: apns} = attributes) do
    %TopicMessage{
      data: Map.get(attributes, :data, %{}),
      notification: Map.get(attributes, :notification, %{}),
      apns: apns,
      topic: topic
    }
  end

  def new(%{topic: topic} = attributes) do
    %TopicMessage{
      data: Map.get(attributes, :data, %{}),
      notification: Map.get(attributes, :notification, %{}),
      topic: topic
    }
  end

  def validate(%TopicMessage{data: _, topic: nil}), do: {:error, "[Message] topic is missing"}

  def validate(%TopicMessage{data: _, topic: _, webpush: nil, android: nil, apns: nil} = message),
    do: {:ok, message}

  def validate(%TopicMessage{data: _, topic: _, webpush: web_message_config} = message)
      when web_message_config != nil do
    case WebMessageConfig.validate(web_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(%TopicMessage{data: _, topic: _, android: android_message_config} = message)
      when android_message_config != nil do
    case AndroidMessageConfig.validate(android_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(%TopicMessage{data: _, topic: _, apns: apns_message_config} = message)
      when apns_message_config != nil do
    case APNSMessageConfig.validate(apns_message_config) do
      {:ok, _} ->
        {:ok, message}

      {:error, error_message} ->
        {:error, error_message}
    end
  end

  def validate(_), do: {:error, "[Message] Invalid payload"}
end
