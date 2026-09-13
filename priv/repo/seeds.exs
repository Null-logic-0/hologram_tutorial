alias HologramTutorial.Repo
alias HologramTutorial.Tasks.Task

[
  "Film Hologram Tutorial",
  "Hit the GYM",
  "Review pull requests",
  "Finish reading the book"
]
|> Enum.each(fn todo ->
  Repo.insert!(%Task{todo: todo})
end)
