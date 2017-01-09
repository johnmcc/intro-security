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

[i] Take a look in psql and demonstrate that there is one user present - admin / password. (Emphasise that this is a contrived example - this isn't how you should handle user authentication!)

[i] Then, go to [http://localhost:4567/authenticate/admin/password](http://localhost:4567/authenticate/admin/password) and demonstrate that the page is running some SQL (./models/user.rb) to check the user's credentials

[i] Finally, show the students the following specially crafted URL:
http://localhost:4567/authenticate/admin/password'; INSERT INTO injection_users (username, password) VALUES ('evil_hacker','password');--

[i] Talk them through what's happening here, open the URL in your browser, then confirm in PSQL that the hacker has added their details to the database. (Make sure you copy / paste the full URL!)

## Escaping HTML

When we take any information from the user, we have to be really careful to restrict what we put out to the browser. If we allow the user to use HTML without restriction, they will be able to include malicious scripts in your application.

```
# Terminal
createdb escape_html

psql -d escape_html -f ./db/seed.sql
ruby app.rb
```

[i] Take a look at http://localhost:4567/users/1 to see what the page should look like. 

[i] Next, load up http://localhost:4567/users/2 and notice that a malicious message has popped up. Explain that although the script is relatively harmless in this case, a malicious script could pass on visitors' credentials to a third party (for example.)

## General strategies

Let's think about the two types of attack we've seen today. What do they have in common?

[i] Let the students bounce some ideas around. Hopefully, they'll head towards...

Both of these attacks assume that the data the user inputted was trustworthy. This is one of the most important takeaway points of today's session: *never trust data that comes directly from the user*. What does this mean in practice?

- Be as strict as possible when you're validating data from the user. If a value should always be an integer, make sure that you're working with an integer - don't accept a string!
- Use the tools that your chosen frameworks provide for sanitizing data. For example, in Ruby's PG gem, you should make use of Prepared Statements.

Be aware that the most vulnerable parts of your app are the parts where users interact with it! Let's have a think about some of the different ways they might be able to do this.

[i] Again, let the students discuss the various means of interacting with, say, a web app. Write them on the board as they come up. Here are some potential answers:

- The URL that the user enters / clicks on
- Forms submitted by the user
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

## Homework

Investigate specific solutions to the insecurities above.

- For SQL injection attacks, read into "prepared statements"
- For cleaning up user submitted HTML, look into the "sanitize" gem.