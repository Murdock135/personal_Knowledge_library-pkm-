This document is the full description on how you work, which consists of two things- (1) Organization and (2) Usage. And I mean EVERYTHING. All the way from your paper scribbles to your github repos. To get a fast overview of how you work, read [[Principles for working as a researcher]].
*Note:* You could also think of the components in 'layers', [a concept taken from computer networking](https://en.wikipedia.org/wiki/OSI_model) where in the physical layer you'd have books, papers and notes. In layer 2, you'd have software. In layer 3, you'd have the content within those software, and so on.
# 1. Introduction


#  2. Organization
How you work entirely depends on how you organize the components of your work. (If you are a CS PhD like me, I believe these will be those components: [[#Components of work (as a CS PhD)]]). We normally have many many components that ideally work together. But I've found that this ideal case is very difficult to realize. We tend to categorize things and just stop there, not thinking about whether the categorization helps being productive. To come up with a better way of organizing these components, I've articulated a goal and the underlying principles in [[#How I organize these components]].
## 2.1 Components of work (as a CS PhD)
The components that I usually have to work with are-
1. Books and Papers.
2. Notes, meeting notes and logs.
3. Configuration files for my computer.
4. Git Repos.
5. Data.
6. Journal
## 2.2 How I organize these components
Organization is key for being productive. But *how you organize* depends on what your ultimate goal is and the components you work with. For example, the goal for when you're organizing house and personal documents is **indexed storage**. But the goal for when you're organizing **work** is **productivity**. We do this by following two principles - 
1. **Minimize friction** between referencing and turning that reference into an actionable document e.g. referencing your work logs and using those logs for ideation.
2. **Maximize interaction** between different document types (e.g. logs, scribbles, notes).
Refer to [[#Scenarios to explain what I mean]] for some examples on how to do follow these principles.
## 2.3 Scenarios to explain what I mean:
### Bad scenario 1:
You work on a project for several months. You keep your work logs in an excel sheet by indexing them by dates.
In this scenario, the work logs don't serve any other purpose other than as proof that you did some form of work. It doesn't enhance productivity.
### Good scenario 1:
You work on a project for several months. You keep your logs in an excel file and tag them with the following tags: \#idea \#idea_rejected \#idea_accepted \#to_do, etc. and for every idea accepted, you link the idea with the document that follows up on it. This is a good practice because then that log entry, which is actually an idea, doesn't rot and you can then increase productivity from it.
### Bad scenario 2:
You take meeting notes for several months. You properly format the meeting notes.
In this scenario, you may lose track of how many of the previous meeting notes you need to refer to to decide next steps or you may even scratch your head trying to figure out *which* of the meeting notes and which particular bullet points need refining or discarding altogether.
### Good scenario 2:
You take meeting notes for several notes. 
1. You tag them in a similar way to Good scenario 1. Benefits are the same as well.
## 2.4 Component 1: Sribbles
Scribbles are chaotic, spur-of-the-moment thoughts or rough attempts at understanding something. There should be no administration or bureaucracy associated with creating scribbles. The only thing to do is to store them after done scribbling. 
Adding a date to a scribble doesn't add value since a scribble's validity is perpetual. Even if the scribble was made years ago, there might be something valuable in it for your current project. 

In summary,
- Scan and store into google drive after done scribbling.
- Summarize what you scribbled about when you have time (Preferably right after. Just takes max 5m).
- Don't add a date.
- If the scribble is rejected entirely, move into 'archived' folder.
## 2.5 Component 2: Logs and Meeting notes
Logs are brief descriptions of what you worked on, usually marked by time. But under the surface, logs carry a lot of information. Things like *why* you spent time on that work and if the work helps produce more work in the future or if this task is something you're stuck on and perhaps need advice on. We forego all this information for simply having a record of what we worked on, which adds minimal productivity. 
But how do we make logs actionable? Firstly, logs are part of a task, which is part of a project. Secondly, logs can (and should) contain information on whether you found any interesting results, whether the task referred to in the log gave birth to a new task (to-do), etc. The simplest thing we can think of is to add tags, which we can filter and find logs efficiently, which we can then act upon. So I use the following structure <\#project>\#task><#\status><#\priority><\#optional tags>, for example: ==\#salmonella_study\#merging\#continue\#low_priority==. I'm using the following status tags:
1. \#continue
2. \#discontinued
I recommend the following optional tags:
3. \#update
4. \#fix
**Where I keep logs and meeting notes:** I write my logs and meeting notes under the `400_projects/projectname/logs` `400_projects/projectname/meeting_notes` and then sync these folders with a folders I keep in my project-specific directory that's not in this vault.
## 2.6 Component 3: Papers
**TLDR**: Simply tag as 'abstract', 'full paper' and/or 'interesting'. Review all your papers once a month. 
At different times, different papers take precedence in terms of importance. Sometimes you think a paper is important to read from beginning to end but they're not. Furthermore, just because you've already read a paper doesn't mean you don't have to read it again. Here are a few approaches to schedule paper-reading.
1. **Categorize by 'abstract' and 'full'**: This method says 'keep papers in the abstract category and once you've read the abstract, if it seems important, put into the 'full' category. You should read papers in the 'full' category from beginning to end.
2. **Tag as 'urgent':**. Tag with 'urgent' if urgent. 
## 2.7 Component 4: Git
Follow the naming convention here unless it is simply impossible to use it.
- Naming convention- type- name e.g. 'research-nn_to_rulefoam'.
- Separate words in the 'name' should be separated by an underscore and not a hyphen.
The types of repos are the following
1. research
2. coursework
3. sandbox
## 2.8 Component 5: Data
As a researcher in AI, I always have to work with data. Usually, a project uses its exclusive set of datasets. However, it's not impossible for multiple projects to use the same dataset. So I keep all my data *flat* in the `C/documents/data/raw` folder. Once a dataset is kept here, it is immutable. This directory serves as a source of truth. 
All processed data are kept in `data/processed`. Alongside the datasets, it is important to log all the transformation steps applied on the raw datasets to realize their processed versions. So in the `data/processed` folder, maintain a `transformations.md` file to log the transformation steps.

## 2.7 Component: Journals
Nothing special. Just keep a journal.
# 3. Principles of working as a researcher
- Schedule obligations first. Then engage in self imposed projects and tasks.
- Always have a few blank sheets at hand.
- Journaling about what you're about to study is recommended.
- Talk to mentors and professors when stuck.
- Schedule reading. This should be a regular practice.