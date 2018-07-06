defmodule Mix.Tasks.NifGen.New do
  use Mix.Task
  import Mix.Generator

  @shortdoc "Creates a new Nif application"

  @new [
    {:eex, "new/config/config.exs", "config/config.exs"},
    {:eex, "new/test/test_helper.exs", "test/test_helper.exs"},
    {:eex, "new/test/app_name_test.exs", "test/app_name_test.exs"},
    {:eex, "new/lib/app_name.ex", "lib/app_name.ex"},
    {:text, "new/.gitignore", ".gitignore"},
    {:text, "new/.formatter.exs", ".formatter.exs"},
    {:eex, "new/mix.exs", "mix.exs"},
    {:eex, "new/README.md", "README.md"},
    {:eex, "new/Makefile", "Makefile"},
    {:eex, "new/c_src/app_name/app_name.c", "c_src/app_name/app_name.c"},
    {:eex, "new/c_src/app_name/app_name.h", "c_src/app_name/app_name.h"},
    {:eex, "new/c_src/app_name/app_name.mk", "c_src/app_name/app_name.mk"}
  ]

  # Embed all defined templates
  root = Path.expand("../../../../templates", __DIR__)

  for {format, source, _} <- @new do
    unless format == :keep do
      @external_resource Path.join(root, source)
      def render(unquote(source)), do: unquote(File.read!(Path.join(root, source)))
    end
  end

  @moduledoc """
  """

  @switches [app: :string, module: :string, target: :keep, cookie: :string]

  def run(argv) do
    {opts, argv} =
      case OptionParser.parse(argv, strict: @switches) do
        {opts, argv, []} ->
          {opts, argv}

        {_opts, _argv, [switch | _]} ->
          Mix.raise("Invalid option: " <> switch_to_string(switch))
      end

    case argv do
      [] ->
        Mix.Task.run("help", ["nif_gen.new"])

      [path | _] ->
        app = opts[:app] || Path.basename(Path.expand(path))
        check_application_name!(app, !!opts[:app])
        mod = opts[:module] || Macro.camelize(app)
        check_module_name_validity!(mod)
        check_module_name_availability!(mod)

        run(app, mod, path, opts)
    end
  end

  def run(app, mod, path, _opts) do
    binding = [
      app_name: app,
      app_module: mod
    ]

    copy_from(path, binding, @new)
    # Parallel installs
    install? = Mix.shell().yes?("\nFetch and install dependencies?")

    File.cd!(path, fn ->
      extra =
        if install? && Code.ensure_loaded?(Hex) do
          cmd("mix deps.get")
          []
        else
          ["  $ mix deps.get", "  $ mix release.init"]
        end

      print_mix_info(path, extra)
    end)
  end

  def recompile(regex) do
    if Code.ensure_loaded?(Regex) and function_exported?(Regex, :recompile!, 1) do
      apply(Regex, :recompile!, [regex])
    else
      regex
    end
  end

  defp cmd(cmd) do
    Mix.shell().info([:green, "* running ", :reset, cmd])

    case Mix.shell().cmd(cmd, quiet: true) do
      0 ->
        true

      _ ->
        Mix.shell().error([
          :red,
          "* error ",
          :reset,
          "command failed to execute, " <>
            "please run the following command again after installation: \"#{cmd}\""
        ])

        false
    end
  end

  defp print_mix_info(path, extra) do
    command = ["$ cd #{path}"] ++ extra

    Mix.shell().info("""
    Your Elixir nif project was created successfully.

    #{Enum.join(command, "\n")}
    """)
  end

  defp switch_to_string({name, nil}), do: name
  defp switch_to_string({name, val}), do: name <> "=" <> val

  defp check_application_name!(name, from_app_flag) do
    unless name =~ recompile(~r/^[a-z][\w_]*$/) do
      extra =
        if !from_app_flag do
          ". The application name is inferred from the path, if you'd like to " <>
            "explicitly name the application then use the `--app APP` option."
        else
          ""
        end

      Mix.raise(
        "Application name must start with a letter and have only lowercase " <>
          "letters, numbers and underscore, got: #{inspect(name)}" <> extra
      )
    end
  end

  defp check_module_name_validity!(name) do
    unless name =~ recompile(~r/^[A-Z]\w*(\.[A-Z]\w*)*$/) do
      Mix.raise(
        "Module name must be a valid Elixir alias (for example: Foo.Bar), got: #{inspect(name)}"
      )
    end
  end

  defp check_module_name_availability!(name) do
    name = Module.concat(Elixir, name)

    if Code.ensure_loaded?(name) do
      Mix.raise("Module name #{inspect(name)} is already taken, please choose another name")
    end
  end

  defp copy_from(target_dir, binding, mapping) when is_list(mapping) do
    app_name = Keyword.fetch!(binding, :app_name)

    for {format, source, target_path} <- mapping do
      target = Path.join(target_dir, String.replace(target_path, "app_name", app_name))

      case format do
        :keep ->
          File.mkdir_p!(target)

        :text ->
          create_file(target, render(source))

        :append ->
          append_to(Path.dirname(target), Path.basename(target), render(source))

        :eex ->
          contents = EEx.eval_string(render(source), binding, file: source, trim: true)
          create_file(target, contents)
      end
    end
  end

  defp append_to(path, file, contents) do
    file = Path.join(path, file)
    File.write!(file, File.read!(file) <> contents)
  end
end
