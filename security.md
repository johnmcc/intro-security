# Introduction to writing secure code

#### Objectives

- Be able to identify and understand some of the most common types of vulnerability
- Understand and use some strategies that will help to mitigate these vulnerabilities
- Understand at a more general level some of the precautions we can take to secure our applications

## Introduction

So far, we have assumed that users of our applications will be acting in good faith. But unfortunately, in the real world, we can't make such an assumption - we have to take steps to ensure that our applications are as secure as we can possibly make them.

Perhaps the first thing to note is that it is - unfortunately - almost impossible to make sure that every layer of our application is secure. Attackers targeting your work might go after:

- Your server's operating system
- The web server you're using
- The database server you're using
- The programming language you use
- Your application's code

And if that fails, they might rely on tricking your users into revealing private information ("social engineering" attacks) or any number of other strategies.

In the face of all this, it might seem like a waste of time to even try to secure your code. *This couldn't be further from the truth*.

You should still do everything you can to make it difficult for people looking to gain unauthorised access to your system. Additionally, your future employers (not to mention your users!) will want to know that you take your responsibilities seriously.

We're going to look at two of the most common attack vectors, then we're going to look at some general strategies for thinking about securing your code.

## SQL Injection

SQL injection is a type of attack where the user maliciously alters the SQL that is passed to your database server. Let's look at an example.

```
# Terminal
createdb injection_users

psql -d injection_users -f ./db/seed.sql
ruby app.rb
```

Take a look in psql and confirm there is one username / password in there. (This isn't how you would usually store user information - this is a slightly contrived example.)

Go to [http://localhost:4567/authenticate/admin/password](http://localhost:4567/authenticate/admin/password). Notice that the page is running and demonstrate that the page is running some SQL (./models/user.rb) to check the user's credentials.

Enter the following malicious URL in the URL bar of your browser:
http://localhost:4567/authenticate/admin/password'; INSERT INTO injection_users (username, password) VALUES ('evil_hacker','password');--

(Make sure you copy it all.)

Check the users table in psql again - notice that there's another user in the table!

Copy and paste the second query parameter into the model's code to understand what's going on - the query is being modified to insert a second user.

How can we get around this? There are at least two strategies.

### Escape the strings that are being passed to the database.

We can call a method on the `db` object to clean the username and password before it gets to the database:

```
sql = "SELECT * FROM injection_users WHERE username='#{db.escape_string(username)}' AND password='#{db.escape_string(password)}';"
```

However, this isn't the best solution. We'd have to do this every time we pass a value to the database.

### Prepared Statements

A better solution is to use prepared statements, which automatically clean the parameters coming in:

```
def self.authenticate(username, password)
  db = PG.connect({ host: 'localhost', dbname: 'injection_users' })
  db.prepare("check", "SELECT * FROM injection_users WHERE username=$1 AND password=$2;")
  result = db.exec_prepared("check", [username, password])
  db.close
  return result.count > 0 ? true:false
end
```

## Escaping HTML

When we take any information from the user, we have to be really careful to restrict what we put out to the browser. If we allow the user to use HTML without restriction, they will be able to include malicious scripts in your application.

```
# Terminal
createdb escape_html

psql -d escape_html -f ./db/seed.sql
ruby app.rb
```

Take a look at http://localhost:4567/users/1 to see what the page should look like. 

Next, load up http://localhost:4567/users/2 and notice that a malicious message has popped up. Although the script is relatively harmless in this case, a malicious script could pass on visitors' credentials to a third party (for example.)

Ideally, you would sanitize the user's input when it was entered, with some form validation. In this case, we're going to look at another strategy - sanitizing using Ruby's Sanitize gem.

```
# Terminal
gem install Sanitize
```

Within our controller, let's require the gem we've just installed:
```
require './models/user'

# added!
require 'sanitize' 

require 'sinatra'
require 'sinatra/contrib/all'
```

And finally, using the sanitize gem in the layout:

```
<%= Sanitize.clean(@user.bio) %>
```

## General strategies

Let's think about the two types of attack we've seen today. What do they have in common?

Both of these attacks assume that the data the user inputted was trustworthy. This is one of the most important takeaway points of today's session: *never trust data that comes directly from the user*. What does this mean in practice?

- Be as strict as possible when you're validating data from the user. If a value should always be an integer, make sure that you're working with an integer - don't accept a string!
- Use the tools that your chosen frameworks provide for sanitizing data. For example, in Ruby's PG gem, you should make use of Prepared Statements.

Be aware that the most vulnerable parts of your app are the parts where users interact with it! Let's have a think about some of the different ways they might be able to do this.

- The URL that the user enters / clicks on
- Forms submitted by the user (File upload fields can be particularly vulnerable)
- Values stored locally on users' devices - for example cookies, localstorage etc.

The most vulnerable parts of your app are the parts where users interact with it. So, start with these areas of your app. Put yourself in an attackers shoes. Think - if you were an attacker, would you be able to compromise this part of the app somehow?

Some more general points:

- Make sure that any software you're using is kept up to date.
- Follow your chosen frameworks on social media channels to stay up to date. Some communities have security mailing lists, so be proactive, and find this out
- Be a good citizen - follow the [responsible disclosure](https://en.wikipedia.org/wiki/Responsible_disclosure) model.

## Responsible Disclosure and ethical considerations

Sometimes, in the course of your work, you might come across a security vulnerability in someone else's work. This might be in an open-source project you use, or a commercial operation of some kind.

You first instinct might be to make this knowledge public, but you should resist this tempation. Instead, you should:

- Make as much information available to the project as you can
- Keep this information private - between you and the other party - until they can resolve the issue

You should also be aware that looking for vulnerabilities in others' systems is an offence under UK law. Even something as simple as trying to guess someone's password, or reading someone's webmail is likely to be illegal. It is no defence that you intended to help them to secure their systems.

The only exception to this is where companies explicitly encourage you to find and report vulnerabilities you might find. Some will even pay you well. For example:

- [Google](https://www.google.com/about/appsecurity/reward-program/index.html)
- [Facebook](https://www.facebook.com/whitehat)
- [Snapchat](https://hackerone.com/snapchat)
- [A big list of bug bounties](https://bugcrowd.com/list-of-bug-bounty-programs)