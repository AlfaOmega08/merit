# Merit

Merit adds reputation behavior to Rails apps in the form of Badges and Points.

[![Build Status](https://travis-ci.org/tute/merit.png?branch=master)](http://travis-ci.org/tute/merit)
[![Code Climate](https://codeclimate.com/github/tute/merit.png)](https://codeclimate.com/github/tute/merit)


# Table of Contents

- [Badges](#badges)
    - [Creating Badges](#creating-badges)
        - [Example](#example)
    - [Usage](#usage)
    - [Displaying Badges](#displaying-badges)
- [Points](#points)
    - [Usage](#usage-1)
    - [Displaying Points](#displaying-points)

# Installation

1. Add `gem 'merit'` to your `Gemfile`
2. Run `bundle install`
3. Define badges in `config/initializers/merit.rb`.

# Badges

## Creating Badges

Create badges in `config/initializers/merit.rb`

`Merit::Badge.create!` takes a hash describing the badge:
* `:id` integer (reqired)
* `:name` this is how you reference the badge (required)
* `:level` (optional)
* `:description` (optional)
* `:custom_fields` hash of anything else you want associated with the badge (optional)

### Example

```ruby
Merit::Badge.create!(
  id: 1,
  name: "Yearling",
  description: "Active member for a year",
  custom_fields: { difficulty: :silver }
)
```

## Usage

```ruby
# Check granted badges
current_user.badges # Returns an array of badges

# Grant or remove manually
current_user.add_badge(badge.id)
current_user.rm_badge(badge.id)
```

```ruby
# Get related entries of a given badge
Badge.find(1).users
```

## Displaying Badges

Meritable models have a `badges` method which returns an array of associated
badges:

```erb
<ul>
<% current_user.badges.each do |badge| %>
  <li><%= badge.name %></li>
<% end %>
</ul>
```


# Points

## Examples

```ruby
# Score points
current_user.add_points(20, category: 'Optional category', message: 'You answered a question')
current_user.subtract_points(10, category: 'Optional category')
```

```ruby
# Query awarded points since a given date
score_points = current_user.score_points(category: 'Optional category')
score_points.where("created_at > '#{1.month.ago}'").sum(:num_points)
```

## Displaying Points

Meritable models have a `points` method which returns an integer:

```erb
<%= current_user.points(category: 'Optional category') %>
```

If `category` left empty, it will return the sum of points for every category.

```erb
<%= current_user.points %>
```
