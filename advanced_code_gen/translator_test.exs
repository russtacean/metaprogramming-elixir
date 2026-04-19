ExUnit.start()
Code.require_file("translator.ex", __DIR__)

defmodule TranslatorTest do
  use ExUnit.Case

  defmodule I18n do
    use Translator

    locale("en",
      foo: "bar",
      notice: [
        alert: "Alert!",
        hello: "Hello, %{first} %{last}!"
      ],
      users: [
        title: "Users",
        profile: [
          title: "Profiles"
        ]
      ]
    )

    locale("fr",
      flash: [
        notice: [
          hello: "Salut %{first} %{last}!"
        ]
      ]
    )
  end

  test "it recursively walks translation trees" do
    assert I18n.t("en", "users.title") == "Users"
    assert I18n.t("en", "users.profile.title") == "Profiles"
    assert I18n.t("en", "notice.alert") == "Alert!"
  end

  test "it handles translations at root level" do
    assert I18n.t("en", "foo") == "bar"
  end

  test "it interpolates bindings" do
    assert I18n.t("en", "notice.hello", first: "John", last: "Doe") == "Hello, John Doe!"
    assert I18n.t("fr", "flash.notice.hello", first: "John", last: "Doe") == "Salut John Doe!"
  end

  test "t/3 returns {:error, :no_translation} when translation is missing" do
    assert I18n.t("en", "notice.does_not_exist") == {:error, :no_translation}
  end
end
