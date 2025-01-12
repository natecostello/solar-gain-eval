-- git-version.lua
local pandoc = require 'pandoc'

-- Helper function to run a command and capture the output
local function capture(command)
  local file = io.popen(command)
  local output = file:read('*all')
  file:close()

  return output:match("^%s*(.-)%s*$") -- trim any leading/trailing whitespace
end

function Meta(meta)
  -- Capture the git describe output for the version
  local git_version_raw = capture("git describe --tags")

  -- Capture the git commit date
  local git_commit_date = capture("git log -1 --format=%ad --date=short")

  -- If the command fails or no tags exist, we just set git_version_raw to an empty string
  if git_version_raw == "" then
    return meta  -- No need to modify the subtitle if there's no git version
  end

  -- Parse the git version and format it according to the desired logic
  local tag, commits, commit_hash = git_version_raw:match("^(.-)-(%d+)-g(%w+)$")

  local git_version = ""
  if tag and commits and commit_hash then
    -- If there are additional commits, format as "(Version [tag] + [hash])"
    git_version = "(Version " .. tag .. " + " .. commit_hash .. ")"
  else
    -- If it's exactly at the tag, format as "(Version [tag])"
    git_version = "(Version " .. git_version_raw .. ")"
  end

  -- Handle appending git_version to meta.subtitle
  if meta.subtitle and type(meta.subtitle) == "table" and meta.subtitle.t == nil then
    -- If the subtitle is of type Inlines (Pandoc), append git version properly
    table.insert(meta.subtitle, pandoc.Space())  -- Add a space before the version
    table.insert(meta.subtitle, pandoc.Str(git_version))  -- Add the git version

  elseif type(meta.subtitle) == "string" then
    -- If the subtitle is a string, append the git version directly
    meta.subtitle = meta.subtitle .. " " .. git_version

  else
    -- If no subtitle exists, just set the git version as the subtitle
    meta.subtitle = pandoc.Inlines({ pandoc.Str(git_version) })
  end

  -- Set the date field to the Git commit date
  if git_commit_date ~= "" then
    meta.date = git_commit_date
  end

  return meta
end

  