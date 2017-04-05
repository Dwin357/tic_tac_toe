class CommandLineInterface
  def display(output)
    puts output
  end

  def prompt(prompt_marker)
    print prompt_marker
    gets.chomp
  end

  def faux_prompt(prompt_marker)
    print prompt_marker
  end
end
