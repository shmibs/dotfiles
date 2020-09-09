defmodule IExConfigInit do

  def init do
    user = System.get_env "USER"    

    hostname = case :inet.gethostname do
      {:ok, s} -> s
      _ -> "?"
    end

    dir = case Elixir.File.cwd do
      {:ok, s} -> s
      _ -> "?"
    end

    home = System.get_env "HOME"

    dir = if home do
      dir = case Regex.compile("^" <> home) do
        {:ok, r} -> Regex.replace r, dir, "~"
        _ -> dir
      end
      dir
    else
      dir
    end

    Application.put_env(:elixir, :ansi_enabled, true)

    IEx.configure(
      colors: [enabled: true],
      default_prompt: [
        # "\e[1A",
        "\e[G",    # ANSI CHA, move cursor to column 1
        :bright,
        :white,
        "┌[",
        :magenta,
        (if user, do: user <> "@", else: ""),
        "elixir-",
        Elixir.System.version,
        "@",
        hostname,
        " ",
        :blue,
        dir,
        :white,
        "]\n",
        "└:",
        :reset
      ] |> IO.ANSI.format |> IO.chardata_to_string,
      alive_prompt: [
        # "\e[1A",
        "\e[G",    # ANSI CHA, move cursor to column 1
        :bright,
        :white,
        "┌[(",
        :blue,
        "%node",
        :white,
        ")",
        :magenta,
        (if user, do: user <> "@", else: ""),
        "elixir-",
        Elixir.System.version,
        "@",
        hostname,
        " ",
        :blue,
        dir,
        :white,
        "]\n",
        "└:",
        :reset
      ] |> IO.ANSI.format |> IO.chardata_to_string,
      continuation_prompt: "   ",
      alive_continuation_prompt: "   "
    )
  end

end

IExConfigInit.init
