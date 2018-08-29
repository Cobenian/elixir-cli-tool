# elixir-cli-tool
CLI tool for calling elixir functions

## Usage

Use the `@` symbol to indicate where you would like the text from stdin to be passed in your code.

### Read all lines from stdin

Call el with no flags and it will read all the lines from stdin and pass them to your code as a list of strings.

Example:

A more verbose verison of `wc -l`
```bash
cat some_file.txt | el "Enum.count(@)"
```

Drops the header row from the output...
```bash
df -h | el "Enum.drop(@, 1)"
```

### Read one line at a time

Call el with the -l flag and it will read one line at a time and evaluate the code for the given line.

Example:

```bash
cat some_file.txt | el -l "String.upcase(@)"
```

### Pipelines

Note that you can combine commands via pipes AND use Elixir's pipe operator.

```bash
df -h | el "Enum.drop(@, 1)" | el -l "String.upcase(@)" | el -l "String.split(@) |> Enum.at(3)"
```
