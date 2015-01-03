path = require "path"
shell = require "shelljs"
exec = require "./exec"
error = require "./../error"
logger = require "./../logger"
log = logger.create "ruby"
synt_rb = path.join __dirname, "..", "..", "bin", "cli-rb"

abs_path = (p) -> path.join process.cwd(), p

compare_ruby = (app) ->
  if not shell.which "bundle"
    return error "Can not find bundle in PATH- Ruby support will not work."

  cmd = synt_rb

  cmd += " -s " if app.stringCompare

  # TODO: should port just handle this?
  if !app.stringCompare
    cmd += " -c \"#{abs_path app.compare}\" " if app.compare
    cmd += " -t \"#{abs_path app.to}\" " if app.to
  else
    cmd += " -c \"#{app.compare}\" " if app.compare
    cmd += " -t \"#{app.to}\" " if app.to

  cmd += " -m #{app["min-threshold"]} " if app["min-threshold"]
  cmd += " -n #{app.ngram} " if app.ngram
  cmd += " -a #{app.algorithm} " if app.algorithm

  exec cmd

module.exports = compare: compare_ruby
