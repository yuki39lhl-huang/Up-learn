-- 山东专升本真题结构化题目
-- 由 gen_sd_paper_questions.py 生成；导入请用 UTF-8
USE up_learn;
SET NAMES utf8mb4;

-- ===== 山东 英语 2022 (33 题, published=1) · 山东英语解析·材料5·选择25·写作3·暂缺0·共33 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='英语' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material','Part Ⅰ Cloze（选词填空）','【Word Bank】
A. that B. alone C. his D. concerns E. valuable F. carefully G. need H. added I. productions J. soil K.than L.which

points each, 15 points）
Directions: In this section, there is a passage with ten blanks. You are required to selected one
word, for each blank from a list of choices given in the box. Read the passage through
carefully before marking your choices. Each choice in the box is identified by a letter. Please
mark the corresponding letter for each choice on the ANSWER SHEET. You may not use any
of the words in the box more than once.
It is estimated that there are now more smartphones 1 people on the planet. The manufacture and disposal
of phones are clear environmental 2 . The US 3 has more than a quarter of a billion phones ready to be
recycled and an extra 11 million are 4 to this figure every month. It is reported 5 less than 20% of these
phones and up is actually being recycled.
The metals that are used in the 6 of smartphones are precious resources. Same 7 metals are often
mined in extremely poor working conditions. If phones are not recycled, more and more of these metals 8 to
be mined to keep up with the demand for new models. And when phones are buried under the ground, harmful
elements leak into the 9 , polluting groundwater. To reduce the negative effect of this problem, we should think
10 about how to recycle our old phones.
A.that B.alone C.his
D.concerns E.valuable F.carefully
G.need H.added I.productions
J.soil K.than L.which',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage One
Many people love to collect things, but why? Psychologists and collectors have different opinions.
The psychologist Carl Jung believed that collecting is part of our ancient human history. Thousands of years
ago, humans collected nuts and berries. They kept them carefully and ate them when there was no food. The best
collectors survived long cold winters or seasons without rain. Their genes passed to future generations. Nowadays,
we still have a collecting instinct.
Historian Philip Bloom has a different opinion. He thinks that collectors want to make something that will
remain after their death. By bringing many similar items together, the collector gains historical importance.
Sometimes their collections become museums or libraries, for example, Henry Huntington, who founded a library
in Los Angeles to house his collection of books.
Author Steve Roach thinks that people collect things to remember their childhood. Many children collect
things, but few have enough money to buy the things they really want, and they lose interest. In later life, they
remember their collections fondly. Now, they have enough money and opportunities to find special items, and they
start collecting again. This way, they can relive and enjoy their childhood years.
Art collector, Werner Muensterberger, agrees that collecting is linked to childhood. But he believes that we
collect in order to feel safe and secure. While babies hold toys to feel safe when their mother isn’t there, adults
collect things to stop feeling lonely or anxious.
Autograph( 亲 笔 签 名 ) collector named Mark Baker agrees that collecting is emotional, but he does not
collect to reduce anxiety. “For me, it’s the excitement,” he says. “I love trying to get a famous person’s autograph.
Sometimes I succeed, and sometimes I fail. Also, by collecting autographs, I feel connected to famous people. I
don’t just watch them on television. I actually meet them.”
These are just a few reasons collecting. Do you know any people with collections? Why do they collect?',NULL,NULL,NULL,0,'reveal_only'),
(@pid,3,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage Two
For many blind people and those with vision difficulties, life can be made easier with a guide dog. However
making a good guide dog takes much work. For many, the long road begins when the dog is a puppy(幼犬).
Take for example, the five 8-week-old puppies that arrived at the Tipton Airport in Maryland early in
February. They were loving, playful animals - like all puppies. Now, however, these puppies are on the road to
becoming useful members of society. If they prove themselves able, they could become guide dogs. They will
help to improve the lives of people with vision loss and vision impairment. These faithful- friends- to- be are part
of a training program of an organization called the Guiding Eyes for the Blind. Bom in New York, these puppies
spent the first two months of their lives with their mothers. They were bred(饲 养 ) for health and the way they
respond to their environment.
However, breeding alone will not be enough to turn these puppies into guide dogs. The puppies flew from the
organization’s head office in New York to Maryland. They will need training from dog training experts. They will
also need to be looked after by volunteers(志愿者) called the Puppy Raisers. The goal of this caring by the Puppy
Raisers and their families is to turn the dynamic, playful puppies into well-behaved dogs. These are the qualities
needed for a successful guide dog: well-bred, well-trained, and well-behaved.
The process will take about 14 to 16 months of weekly classes and testing. Training starts with the basics:
name recognition, behavior, and commands such as “sit” and “down”. The trainers then move on to more complex
commands. After that, the puppies are given to the Puppy Raisers. The raisers and their families will show the
puppies the world and how to act in it.
Cindy Tait, the Puppy Program manager of the Guiding Eyes for the Blind, said that other experts would
keep a watchful eve on the training and help with any problems the raisers may have along the way. Once a solid,
loving foundation is in place, puppies must leave their raisers and return to the training center of the Guiding Eyes
for the Blind in New York for official guide dog training. Formal training is where the dogs demonstrate whether
they will become a guide dog for the blind.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,4,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage Three
An Food delivery services are a major contributor to single-use plastic waste. Plastic containers, drinking
cups, and straws make up about 269,000 tons of plastic found in the oceans.
Restrictions on in-person dining during the COVID-19 pandemic lead many consumers to shift from
in-person dining to takeout orders, increasing plastic waste. For something that is used very briefly for
convenience, single-use plastics have long-term environmental consequences. Luckily, there are several ways for
consumers to reduce their plastic use to the lowest level.
The first thing that anyone can do is simply not to use single-use plastics when it is not necessary. Consumers
can refuse the use of unnecessary single-use items when they order takeout.
“If you’d like to see plastic waste reduced, write in the notes when you order that you don’t want the extra
packaging that might typically come with your order,” says John Mann, executive director of a nonprofit
organization. “Call and politely tell them you support reducing plastic waste and see if they’ve considered moving
to reusable packaging or other things that aren’t plastic.”
“While individuals play a large',NULL,NULL,NULL,0,'reveal_only'),
(@pid,5,NULL,'material','Part Ⅱ Reading Comprehension · Section B','Your happiness is like a retirement account: the sooner you invest, the greater your return will be, just as
financial planners advise their clients to engage in a specific behavior. We can all teach ourselves to do some
specific sense at any age to make our last decades much happier. 26
Don''t smoke. 27 The earlier you start the quitting process, the more smoke-free years you can invest in
your happiness account.
28 If you have any drinking problem in your life, get help now. Although quitting drinking can be difficult,
you will never be sorry if you make this decision.
Keep learning. 29 You don’t have to go to Harvard, you simply need to engage in lifelong learning.
30 For most people, this includes a steady marriage, but other relationships with family, friends, and
partners matter as well. The point is to find people with whom you can grow no matter what comes. You may
develop the habits today and see where you need to invest a little more time, energy, or money. Starting moving in
the right direction.
A. Watch your drinking.
B. If you already smoke, quit now.
C. Maintain a healthy body weight.
D. She is shocked when I show her the data.
E. Develop stable, long-term relationships now.
F. More education means a more active mind in old age.
G. Here are some habits that could lead to happiness in old age.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,6,1,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 1 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,7,2,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 2 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,8,3,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 3 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,9,4,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 4 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,10,5,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 5 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,11,6,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 6 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,12,7,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 7 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,13,8,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 8 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,14,9,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 9 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,15,10,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 10 空',JSON_ARRAY('A. that','B. alone','C. his','D. concerns','E. valuable','F. carefully','G. need','H. added','I. productions','J. soil K.than L.which'),NULL,NULL,2,'answerable'),
(@pid,16,11,'choice','Part Ⅱ Reading Comprehension · Section A','Carl Jung believed that collecting is _____.',JSON_ARRAY('A. an instinct for survival','B. an approach to growing berries','C. a means of learning psychology','D. a way of praying for good weather'),NULL,NULL,2,'answerable'),
(@pid,17,12,'choice','Part Ⅱ Reading Comprehension · Section A','According to Philip Bloom, people collect things to _____.',JSON_ARRAY('A. write books for libraries','B. build houses in Los Angeles','C. build theatres in Los Angeles','D. acquire historical significance'),NULL,NULL,2,'answerable'),
(@pid,18,13,'choice','Part Ⅱ Reading Comprehension · Section A','According to Steve Roach,why do many children lose interest in collecting things?',JSON_ARRAY('A. Because they hold toys to feel safe.','B. Because they have too many special items.','C. Because they cannot remember their collections.','D. Because they cannot afford what they really want.'),NULL,NULL,2,'answerable'),
(@pid,19,14,'choice','Part Ⅱ Reading Comprehension · Section A','Mark Baker likes collecting autographs because it _____.',JSON_ARRAY('A. makes him rich','B. makes him famous','C. brings him great joy','D. reduces his anxiety'),NULL,NULL,2,'answerable'),
(@pid,20,15,'choice','Part Ⅱ Reading Comprehension · Section A','What is the passage mainly about?',JSON_ARRAY('A. Methods of collecting.','B. Reasons for collecting.','C. How to become less anxious.','D. How to remember one’s childhood.'),NULL,NULL,2,'answerable'),
(@pid,21,16,'choice','Part Ⅱ Reading Comprehension · Section A','The phrase “the long road” in Paragraph 1 probably refers to _____.',JSON_ARRAY('A. the journey from New York to Maryland','B. the process of turning puppies into guide dogs','C. the journey from Maryland to the Tipton Airport','D. the process of transforming volunteers into puppy raisers'),NULL,NULL,2,'answerable'),
(@pid,22,17,'choice','Part Ⅱ Reading Comprehension · Section A','The word “impairment” in Paragraph 2 is closest in meaning to _____.',JSON_ARRAY('A. damage','B. danger','C. impatience','D. imitation'),NULL,NULL,2,'answerable'),
(@pid,23,18,'choice','Part Ⅱ Reading Comprehension · Section A','Puppies will be trained by the Puppy Raisers to be _____.',JSON_ARRAY('A. well-behaved','B. passive','C. violent','D. well-shaped'),NULL,NULL,2,'answerable'),
(@pid,24,19,'choice','Part Ⅱ Reading Comprehension · Section A','What does the word “it” in Paragraph 4 refer to?',JSON_ARRAY('A. The program.','B. The world.','C. The testing.','D. The class.'),NULL,NULL,2,'answerable'),
(@pid,25,20,'choice','Part Ⅱ Reading Comprehension · Section A','Where will the puppies receive their official guide dog training?',JSON_ARRAY('A. In the manager’s office.','B. In the Puppy Raisers’ homes.','C. In the training center in Maryland.','D. In the training center in New York.'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 26 题',JSON_ARRAY('A. Watch your drinking.','B. If you already smoke, quit now.','C. Maintain a healthy body weight.','D. She is shocked when I show her the data.','E. Develop stable, long-term relationships now.','F. More education means a more active mind in old age.','G. Here are some habits that could lead to happiness in old age.'),NULL,NULL,3,'answerable'),
(@pid,27,27,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 27 题',JSON_ARRAY('A. Watch your drinking.','B. If you already smoke, quit now.','C. Maintain a healthy body weight.','D. She is shocked when I show her the data.','E. Develop stable, long-term relationships now.','F. More education means a more active mind in old age.','G. Here are some habits that could lead to happiness in old age.'),NULL,NULL,3,'answerable'),
(@pid,28,28,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 28 题',JSON_ARRAY('A. Watch your drinking.','B. If you already smoke, quit now.','C. Maintain a healthy body weight.','D. She is shocked when I show her the data.','E. Develop stable, long-term relationships now.','F. More education means a more active mind in old age.','G. Here are some habits that could lead to happiness in old age.'),NULL,NULL,3,'answerable'),
(@pid,29,29,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 29 题',JSON_ARRAY('A. Watch your drinking.','B. If you already smoke, quit now.','C. Maintain a healthy body weight.','D. She is shocked when I show her the data.','E. Develop stable, long-term relationships now.','F. More education means a more active mind in old age.','G. Here are some habits that could lead to happiness in old age.'),NULL,NULL,3,'answerable'),
(@pid,30,30,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 30 题',JSON_ARRAY('A. Watch your drinking.','B. If you already smoke, quit now.','C. Maintain a healthy body weight.','D. She is shocked when I show her the data.','E. Develop stable, long-term relationships now.','F. More education means a more active mind in old age.','G. Here are some habits that could lead to happiness in old age.'),NULL,NULL,3,'answerable'),
(@pid,31,31,'essay','Part Ⅲ Translation','What I hate most is to keep birds in cages. We enjoy them while they are shut up in prison. I must say that I always love birds, but there is a proper way of doing it. One who loves birds should plant trees, so that the house will be surrounded with hundreds of shady branches and be a home for birds. Section B（10 points） Directions: Read the following passage carefully and then translate it into English. Your translation should be written clearly on the ANSWER SHEET.',NULL,NULL,NULL,10,'reveal_only'),
(@pid,32,32,'essay','Part Ⅲ Translation','中医是一种独特的医疗体系，也是中国传统文化的重要组成部分。不同于西医，中医把人体当作整体， 与周围环境相互影响。中医博大精深，被认为是中国的第五大发明，值得更多的关注和研究。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','Part Ⅳ Writing','The first National Conference on Reading was held in Beijing on 23 April and a national campaign was launched to promote people’s love of reading. As a college student, how should you play a leading role in this campaign? Your essay should include: Your understanding of the national reading campaign; How to play a leading role in the campaign.',NULL,NULL,NULL,20,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 英语 2023 (33 题, published=1) · 山东英语解析·材料5·选择25·写作3·暂缺0·共33 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='英语' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material','Part Ⅰ Cloze（选词填空）','【Word Bank】
A. if B. which C. take D. medium E. ago F. that G. formed H. placing I. including J. levels K.though L.strategically

points each, 15 points）
Directions: In this section, there is a passage with ten blanks. You are required to selected one
word, for each blank from a list of choices given in the box. Read the passage through
carefully before marking your choices. Each choice in the box is identified by a letter. Please
mark the corresponding letter for each choice on the ANSWER SHEET. You may not use any
of the words in the box more than once.
WeiQi or Go is an interesting board game which originated in China more than 4000 years 1 . The game is
played today by millions people, 2 thousands in the United States. It’s popularity in the United States
continues to grow. It is said 3 rules of Weigi can be learned in minutes. In fact, it can 4 a lifetime to master
the game. The rules could not be simpler. Two players alternate in 5 black and white store on a large ruled
board, with the aim of surrounding territory. Stones never more, and are only removed from the board 6 they
are completely surrounded.
WeiQi can teach concentration balance and discipline. It can also help develop the habit of thinking more 7 .
Each person’s style of play reflects his or her personality and can serve as a 8 for self reflection Weiqi
combines beauty and challenge. The patterns 9 by the black and while stones are visually striking. Children
learn the game easily and can reach high 10 of mastery.
A.if B.which C.take
D.medium E.ago F.that
G.formed H.placing I.including
J.levels K.though L.strategically',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage One
Temperatures are warming and daylight lasts longer. People who like to garden may be ready to get their
hands dirty and start clearing the ground for new plantings. But garden experts warn---not too fast.
Jessica Damiano is one such expert. She says that removing plant matter too early can disturb important
insects not ready for the cool early spring temperatures. In early spring, those insects are still sleeping. Removing
the plant matter before the insects begin their life cycles would mean removing them from your garden. Fewer
insects mean less food for birds and fewer flowers and vegetables for the gardener.
Damiano says experts do not all agree on the best time to start cleaning the ground and garden area in the
spring. But they usually agree lo wait until the temperatures are regularly above 10℃. That is when sleeping
insects “wake up”. Some experts define “regularly” as at least five days in a row. Damiano says she usually waits
seven nights. However, even then, she says to keep the plant matter on the ground for another week or so before
removing it from the garden. This gives any insects that are still “sleeping” enough time to wake up.
Early cleaning of a garden is often followed by early covering the soil with mulch. Applying mulch makes
the garden look neat and clean. But Damiano reminds us that soil and plants are not just for show. They are part of
a living ecosystem.
Mulch is an important part of a healthy garden. It keeps soil wet, limits the growth of grass, and helps keep
soil temperatures even. But timing is important. Mulching before the soil has warmed enough will keep in the cold
and slow the reawakening of the plants. This can also limit their growth. And if the soil is wet, early mulching can
lead to some diseases. Before applying mulch, wait until it is safe to plant warm-season vegetables in your area.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,3,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage Two
The man who made the first call from a wireless phone is now 94 years old. The year was 1973. Martin
Cooper operated a large, heavy, new communication device on a street in New York. The device was not
physically connect to phone lines. But, Cooper was able to make use of it-he called a technology business
competitor.
Fifty years later, the inventor says he hopes wireless phones can make life better but he also expresses some
worries. “My most negative opinion is that we don’t have any privacy anymore because everything about us is
now recorded someplace” Cooper said. And he says he is concerned about how easily young people can link to
harmful online materials on their mobile phones. Cooper spoke with the Associated Press from Barcelona, Spain,
where he attended the Mobile World Congress(MWC), the biggest telecom industry trade show. Cooper received
an award there for his lifetime of work.
Cooper says he is an optimist. He believes the technology’s best days may still be ahead in areas such as
education and health care.” Between the cellphone and medical technology and the internet, we are going to cure
disease he said at the MWC.
Cooper was working for Motorola when he used the Dyna-Tac phone to make a call in April 1973. Things
have changed greatly since then. But he said we had no way of knowing this was the historic moment. Cooper
said there are still ways for the mobile phone to change. The first one he used weighed over 1 kilogram. Today,
they are small. But he thinks one day, they will be more like a part of our body than something we hold. He said
perhaps the human body can even power the phones. “The human body is the charging station, right?” he asked.
The body makes energy from food, he argues, so it could possibly also power a phone. Instead of holding the
phone in the hand, for example, the device could be placed under the skin.
Cooper said he also hopes there can be more protection for internet users concerned about privacy and for
children. Speaking about privacy concerns, he said: “it’s going to get resolved, but not easily.” He also said there
should a special internet for children so they do not run into material made for adults. Cooper said the idea for the
mobile phone came from a communication device used by the comic book character Dick Tracy. The imaginary
detective ha a wristwatch from which he could make phone calls.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,4,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage Three
A new study suggests the singing noises made by humpback whales(座头鲸) might be a sign of loneliness.
Scientists who recorded humpback whale behavior in Australia discovered that fewer whales made the singing
noises, also called wailing as their population grew.
“Humpback whale song is loud and travels far in the ocean,” said Rebecca Dunlop of the University of
Queensland. She has long studied humpback whales and helped lead the new study. Her work has centered on
humpbacks that reproduce near Australia’s Great Barrier Reef.
Dunlop made an unexpected finding as whale numbers sharply rose following the end of commercial
whaling(捕鲸). “It was getting more difficult to actually find singers,” she said. Dunlop added, “when there were
fewer of them, there was a lot of singing-now that there are lots of them, no need to be singing so much.”
Scientists first began to hear and study the complex songs of the humpback whales in the 1970s. They used
underwater microphones to do so. Only male whales sing.
Eastern Australia’s humpback whales came close to disappearing in the 1960s, when their number dropped to
around 200. But over time the population began to regrow, climbing to about 27,000 whales by 2015. That
number is near estimated pre-whaling levels.
As the density of whales increased, their singing behaviors changed. While 2 in 10 males made wailing
noises in 2004, 10 years later the number had dropped to 1 in 10, Dunlop said. The team’s study appeared in a
recent issue of Nature Communications Biology. Dunlop said she thinks singing played a big',NULL,NULL,NULL,0,'reveal_only'),
(@pid,5,NULL,'material','Part Ⅱ Reading Comprehension · Section B','The benefits of having good leadership in the workplace have long been documented. A good leader can
inspire employees to perform at their best, which can improve the efficiency of an organization. 26
Learn from the best. Think about leaders who you have worked under in the past. 27 You should always
ensure that you have all viewpoints before you make your decision. Being a good leader is about commitment to
being a better you. Consider taking an education course, which will be of great help for you.
28 Good leaders must communicate effectively about their intentions, goals and expectations. You can
organize meetings on a regular basis, receive feedback from your employees and never speak in anger to them.
29 A good leader must be able to inspire the employees to approach tasks in the best possible way. To do
this, you must become a hard working person that the employees can follow.
Honor achievers. It is important that the employees who go above and beyond their basic job description
should be rewarded for doing a good job. 30 This is a recognition that it takes all the people below you to
make the company succeed.
A good leader not only accepts that a business is doing well, but also pushes the employees to be better than
they are in order to achieve even more.
A. Lead by example.
B. Be a good communicator.
C. Improve the efficiency of your business.
D. Here are some ways to improve your leadership.
E. You should try to acknowledge a person who works hard.
F. There are as many creative processes as they are creative leaders.
G. Their personal experience and knowledge can help you become a great leader.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,6,1,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 1 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,7,2,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 2 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,8,3,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 3 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,9,4,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 4 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,10,5,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 5 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,11,6,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 6 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,12,7,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 7 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,13,8,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 8 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,14,9,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 9 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,15,10,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 10 空',JSON_ARRAY('A. if','B. which','C. take','D. medium','E. ago','F. that','G. formed','H. placing','I. including','J. levels K.though L.strategically'),NULL,NULL,2,'answerable'),
(@pid,16,11,'choice','Part Ⅱ Reading Comprehension · Section A','What does the underlined phrase “get their hands dirty” in paragraph 1 mean?',JSON_ARRAY('A. To take a boring job','B. To play dirty tricks','C. To do their gardening','D. To sell their vegetables'),NULL,NULL,2,'answerable'),
(@pid,17,12,'choice','Part Ⅱ Reading Comprehension · Section A','What will happen if the plant matter is removed too Early?',JSON_ARRAY('A. More flowers will grow in the garden.','B. Some important insects will be taken away.','C. More sleeping insects will be eaten by birds.','D. The gardener will harvest more vegetables in fall.'),NULL,NULL,2,'answerable'),
(@pid,18,13,'choice','Part Ⅱ Reading Comprehension · Section A','According to Damiano, when can a gardener start clearing the ground for new plantings?',JSON_ARRAY('A. After the flowers come out.','B. After the sleeping insects wake up.','C. Before the temperatures are above 10℃.','D. Before the insects begin their life cycles.'),NULL,NULL,2,'answerable'),
(@pid,19,14,'choice','Part Ⅱ Reading Comprehension · Section A','Damiano thinks that early mulching may _____.',JSON_ARRAY('A. make the insects healthy','B. keep soil temperatures uneven','C. restrict the growth of the plants','D. reawaken the plants quickly'),NULL,NULL,2,'answerable'),
(@pid,20,15,'choice','Part Ⅱ Reading Comprehension · Section A','This passage is probably selected from a _____.',JSON_ARRAY('A. fashion magazine','B. weather report','C. sports newspaper','D. gardening book'),NULL,NULL,2,'answerable'),
(@pid,21,16,'choice','Part Ⅱ Reading Comprehension · Section A','According to Paragraph 1, Martin Cooper _____.',JSON_ARRAY('A. made the first wireless phone call in 1973.','B. invented a device physically linked to phone lines.','C. operated a new communication device 94 years ago.','D. used a wireless phone invented by his business competitor.'),NULL,NULL,2,'answerable'),
(@pid,22,17,'choice','Part Ⅱ Reading Comprehension · Section A','According to Paragraph 2, Cooper thinks that mobile phones can easily _____.',JSON_ARRAY('A. increase business competition','B. protect the privacy of young people.','C. expose children to harmful online materials.','D. do something harmful to online technology.'),NULL,NULL,2,'answerable'),
(@pid,23,18,'choice','Part Ⅱ Reading Comprehension · Section A','What does the underlined word “this” in Paragraph 4 refer to?',JSON_ARRAY('A. The Mobile World Congress.','B. Cooper’s contribution to health care.','C. Cooper’s call via the Dyna-Tac phone.','D. The award for Cooper’s lifetime work.'),NULL,NULL,2,'answerable'),
(@pid,24,19,'choice','Part Ⅱ Reading Comprehension · Section A','Cooper thinks that the mobile phone in the future may _____.',JSON_ARRAY('A. weight over 1 kilogram','B. be made of special metals','C. use energy directly from food','D. be powered by the human body'),NULL,NULL,2,'answerable'),
(@pid,25,20,'choice','Part Ⅱ Reading Comprehension · Section A','According to the last paragraph, what does Cooper suggest about protection for children?',JSON_ARRAY('A. Providing a special internet for them.','B. Offering course on privacy protection','C. Placing the mobile phone under the skin.','D. Allowing them to browse materials for adults.'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 26 题',JSON_ARRAY('A. Lead by example.','B. Be a good communicator.','C. Improve the efficiency of your business.','D. Here are some ways to improve your leadership.','E. You should try to acknowledge a person who works hard.','F. There are as many creative processes as they are creative leaders.','G. Their personal experience and knowledge can help you become a great leader.'),NULL,NULL,3,'answerable'),
(@pid,27,27,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 27 题',JSON_ARRAY('A. Lead by example.','B. Be a good communicator.','C. Improve the efficiency of your business.','D. Here are some ways to improve your leadership.','E. You should try to acknowledge a person who works hard.','F. There are as many creative processes as they are creative leaders.','G. Their personal experience and knowledge can help you become a great leader.'),NULL,NULL,3,'answerable'),
(@pid,28,28,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 28 题',JSON_ARRAY('A. Lead by example.','B. Be a good communicator.','C. Improve the efficiency of your business.','D. Here are some ways to improve your leadership.','E. You should try to acknowledge a person who works hard.','F. There are as many creative processes as they are creative leaders.','G. Their personal experience and knowledge can help you become a great leader.'),NULL,NULL,3,'answerable'),
(@pid,29,29,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 29 题',JSON_ARRAY('A. Lead by example.','B. Be a good communicator.','C. Improve the efficiency of your business.','D. Here are some ways to improve your leadership.','E. You should try to acknowledge a person who works hard.','F. There are as many creative processes as they are creative leaders.','G. Their personal experience and knowledge can help you become a great leader.'),NULL,NULL,3,'answerable'),
(@pid,30,30,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 30 题',JSON_ARRAY('A. Lead by example.','B. Be a good communicator.','C. Improve the efficiency of your business.','D. Here are some ways to improve your leadership.','E. You should try to acknowledge a person who works hard.','F. There are as many creative processes as they are creative leaders.','G. Their personal experience and knowledge can help you become a great leader.'),NULL,NULL,3,'answerable'),
(@pid,31,31,'essay','Part Ⅲ Translation','Your relationship with yourself will last your whole lifetime, so you should regard yourself as your best friend. Getting on well with yourself should be a top priority to you if you want to be a happy person. You can practice self-talk, build confidence, and focus on self-development. A healthy self relationship can help yon create a positive self-image of yourself, which is vital for you to become the best version of yourself. Section B（10 points） Directions: Read the following passage carefully and then translate it into English. Your translation should be written clearly on the ANSWER SHEET.',NULL,NULL,NULL,10,'reveal_only'),
(@pid,32,32,'essay','Part Ⅲ Translation','黄河是中华民族的母亲河，保护黄河生态环境日益重要，我们要行动起来，精心呵护黄河。加强生态环 境保护，促进人与自然和谐发展，创造更加美好的生活。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','Part Ⅳ Writing','Digital literacy skills are important for language learners to find evaluate and communicate information by using technology. As a college student, how should you improve your digital literacy skills for English learning? Your essay should include: (1) the use of digital technology for English learning. (2) the ways of improving digital literacy skills for English learning. You should write at least 100 words in English. Please write your essay on the ANSWER SHEET.',NULL,NULL,NULL,20,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 英语 2024 (36 题, published=1) · 山东英语解析·材料5·选择28·写作3·暂缺0·共36 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='英语' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material','Part Ⅰ Cloze（选词填空）','【Word Bank】
A. using B. after C. affected D. who E. make F. period G. investigates H. whether I. particularly J. habits

points each, 15 points）
Directions: In this section, there is a passage with ten blanks. You are required to select one
word for each blank from a list of choices given in the box. Read the passage through carefully
before making your choices. Each choice in the box is identified by a letter. You may not use
any of the words in the box more than once. Please mark the corresponding letter for each
choice on the ANSWER SHEET with a single line through the center.
A new study finds that getting a family dog is good for kids. The finding is part of a growing body of
research that __1__ how dogs can boost health, not just for kids but for people of all ages.
In the study, Australian researchers followed 600 children over a __2__ of three years. They tracked kids’
physical activities by __3__ monitors that measured things like how fast, long and intensely they moved. They
also surveyed parents about their children’s activities and __4__ they had a family dog or not. The researchers
tried to see how the kids’ activity levels were __5__ by dog ownership.
Perhaps not surprisingly, both boys and girls in the study spent more time in playing in the yard __6__
getting a dog. But the impact was __7__ pronounced in girls. Adding a dog to the household increased young girls’
physical activities by 52 minutes a day. It could __8__ a meaningful difference to their health.
“Having a dog in childhood could help kids create healthy __9__ around physical activities,” says
MacDonald, a professor at Oregon Slate University, __10__ has studied the physical and emotional benefits of
dog ownership in kids.
A.using B.after C.affected D.who E.make
F.period G.investigates H.whether I.particularly J.habits',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage One
Questions 11 to 15 are based on the following passage.
College professors these days face an ever higher bar to grab the attention of their students forced to compete
with the pulling power of smartphones and laptops in large lecture halls. But when your professor is a social
media star, it is a little bit easier.
Tatiana Erukhimova, who teaches physics at Texas A&M University, has managed to get her students, as well
as future generations, excited about the science. Known as “Dr.Tatiana” to her students and online fan base, the
professor performs physics tricks with boundless energy and enthusiasm. Videos of her theatrical demonstrations
have attracted hundreds of millions of views across social media platforms.
As part of the physics department’s extensive program, she also puts on shows almost every week teaching
physics to K-12 students. The sooner kids are taught physics and taught it well, the better, she says. It is clear she
knows what it takes to get young people excited about science. But it was not always that way.
When she first started teaching college freshman classes almost two decades ago, she says she struggled to
grab the attention of her younger students. She was used to teaching juniors, as she had for a few years prior to
that. By junior year, students majoring in physics are committed to learning, she says. But when it comes to
teaching a large lecture hall of 100-plus first-year students, first impressions are make or break.
“I did not grab their attention on the first day—that was my mistake,” she says, “I missed this opportunity to
bond with them from the very beginning.” By the second semester, she adjusted her approach to make her lecture
halls feel smaller, and get her students engaged.
The key, she says, has been to make herself approachable and her instruction personal, “Talk to your students
before and after class, walk up and down the stairs when you teach your class rather than stay on the stage. And
don’t just lecture, talk to them, make it interactive. When you ask the question, you expect the answer,” she says.
“If you don’t have the answer, you go to them and you still make them work with you-it’s not always easy, but
when you’re close to them, it’s definitely easier.”',NULL,NULL,NULL,0,'reveal_only'),
(@pid,3,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage Two
Questions 16 to 20 are based on the following passage.
This is one of two schools in Richmond where the city has installed new enforcement cameras to catch
speeders. Fitz Patrick has two children at the school. She is also a traffic safety advocate for the nonprofit Greater
Richmond Fit 4 Kids, which is why she owns a radar gun（雷达测速器）.
Still, Fitz Patrick has mixed feelings about the speed cameras. She would rather see the whole street
redesigned to discourage speeding and protect walkers and bicyclists. But she also knows that will not happen
anytime soon.
The number of traffic deaths has risen sharply over the past decade, and safety advocates around the country
are desperately searching for anything that will get drivers to slow down. But critics say speed cameras can be a
financial burden on those who are least able to pay. Still, they have earned the support of important safety
advocates, including Jonathan Adkins, the chief executive officer of the Governors Highway Safety Association.
Police departments in many places have scaled down their traffic enforcement, Adkins says, and speeding
and careless driving seem to be getting worse. He says automated cameras can help fill that blank. “The question
is, how do we arrange them in a fair way with the public support?” Adkins said.
No one likes getting a speeding ticket. But the objections to automated traffic enforcement go deeper than
that. “It is doubtful that safety is the real goal,” said Jay Beeber, with the National Motorists Association, a driver
advocacy group.
“We need to make sure that our cities have all the tools that are effective to reduce traffic deaths,” said Laura
Friedman, a state lawmaker in California who sponsored the state law authorizing automated cameras. “We make
sure it can’t be a money grab, because the money can only be used for physical speed-lowering improvements on
the same streets where you’re using the cameras,” she said. “So it’s really about changing the culture and slowing
traffic down.”
l6.Fitz, Patrick has a radar gun because _____.
A.she is a traffic safety advocate
B.she has two children at the school
C.she has new cameras to catch speeders
D.she is a school headmaster in Richmond',NULL,NULL,NULL,0,'reveal_only'),
(@pid,4,NULL,'material','Part Ⅱ Reading Comprehension · Section A','Passage Three
Questions 21 to 25 are based on the following passage.
Experts suggest that Americans stop worrying about getting a perfect eight hours of sleep, and warn that
stressing about the magic number may actually result in a drop in sleep quality and duration.
Dr. Reena Mehra, a director of sleep research at the Cleveland Clinic, held that focusing too much on falling
asleep may interrupt the process, “It works against the individual,” she said. According to the Centers for Disease
Control and Prevention, more than a third of Americans do not achieve the recommended seven to nine hours of
sleep per night,” The agency also found that quality sleep is determined by major sleep episodes that do not have
frequent awakenings.
One paper looking into the ideal amount of sleep found that “Sleep duration recommendations issued by
public health authorities help to inform the population of interventions, policies, and healthy sleep behaviors.
However, the ideal amount of sleep required each night can vary between different individuals due to gene-related
factors and other reasons, and it is important to adapt our recommendations on a case-by-case basis.”
In the past, a lack of sleep was a sign to bosses that a person was productive and successful. But today,
people try to create strategies to make the best use of their rest.
Researchers, scientists, psychologists and individuals in the sleep business said that the best course of action
when it comes to sleep is to relax.
Albert Einstein College of Medicine clinical associate professor of psychology Dr. Shelby Harris said
patterns and routines are more important than the magic eight-hour number. However, she stressed that people do
not need to be so rigid that they can no longer sleep at all if they have to break from their routine to work late or
deal with a restless child. Harris also noted that it is essential to remember that humans were able to sleep
peacefully well before the invention of drugs and technology. “The pressure we put on ourselves is making sleep
worse,” she said.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,5,NULL,'material','Part Ⅱ Reading Comprehension · Section B','Jumping rope has a long history and it is still good for people to do today. __26__
Indeed, the health benefits of jumping rope are many and affect multiple systems throughout the body.
__27__ The exercise is also great for improving blood pressure and heart rate.
__28__ Some reports show that you can burn as many as 500 calories in only 30 minutes of the activity.
When coupled with a calorie-reduced diet, jumping rope can help reduce your body weight and body fat from
three to seven pounds in eight weeks.
Because of such benefits, many want to participate in the activity, though some do not know where to begin.
There are some good tips for beginners.
It is important to get the right rope length to begin with, __29__ As you advance, you may find that a shorter
rope is more to your liking because it will aid you in increasing your skipping rate.
__30__ You should jump softly and low to the ground, and keep your hands low and close to your body. As
you improve, you may add no more than 10% additional volume per week.
It is also important to stretch properly to prevent injuries. You can get your body used to the motion of
jumping up and down before involving the coordination (协调) required of using a rope.
A.The most important thing is to start slow.
B.What are the health benefits of jumping rope?
C.Jumping rope can also help people lose weight.
D.Regular practice of the sport strengthens muscles.
E.Non-running exercises can be beneficial for old people.
F.This simple piece of exercise equipment does not sell well.
G.The rope should be about 3 feet longer than your total height.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,6,1,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 1 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,7,2,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 2 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,8,3,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 3 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,9,4,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 4 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,10,5,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 5 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,11,6,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 6 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,12,7,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 7 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,13,8,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 8 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,14,9,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 9 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,15,10,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 10 空',JSON_ARRAY('A. using','B. after','C. affected','D. who','E. make','F. period','G. investigates','H. whether','I. particularly','J. habits'),NULL,NULL,2,'answerable'),
(@pid,16,11,'choice','Part Ⅱ Reading Comprehension · Section A','According to Paragraph 1, professors find it more difficult to _____.',JSON_ARRAY('A. use smartphones in class','B. become social media stars','C. get students’ attention in class','D. give lectures without using laptops'),NULL,NULL,2,'answerable'),
(@pid,17,12,'choice','Part Ⅱ Reading Comprehension · Section A','What can we learn about Dr.Tatiana from Paragraph 2?',JSON_ARRAY('A. She is a professor of online games.','B. She performs physics experiments in theaters.','C. She gains less energy from social media platforms.','D. She has made many young persons interested in physics.'),NULL,NULL,2,'answerable'),
(@pid,18,13,'choice','Part Ⅱ Reading Comprehension · Section A','Which is closest in meaning to “make or break’ in Paragraph 4?',JSON_ARRAY('A. Normal.','B. Crucial.','C. Breakable.','D. Successful. l4.According to Paragraph 5, Dr.Tatiana _____.'),NULL,NULL,2,'answerable'),
(@pid,19,15,'choice','Part Ⅱ Reading Comprehension · Section A','According to the last paragraph, good teachers should be able to _____.',JSON_ARRAY('A. give their lectures in an interactive way','B. persuade their students to stay on the stage','C. ask questions that most students cannot answer','D. force their students to get well prepared before class'),NULL,NULL,2,'answerable'),
(@pid,20,17,'choice','Part Ⅱ Reading Comprehension · Section A','According to Paragraph 2, Fitz Patrick thinks that _____.',JSON_ARRAY('A. more speed cameras will soon be fixed','B. redesigning the whole street is a better choice','C. state lawmakers should redesign speed cameras','D. the newly-installed cameras encourage speeding'),NULL,NULL,2,'answerable'),
(@pid,21,18,'choice','Part Ⅱ Reading Comprehension · Section A','What is the main idea of Paragraph 3?',JSON_ARRAY('A. Drivers find speed cameras can protect their safety.','B. There are different views on the use of speed cameras.','C. Speed cameras have caused a sharp rise in traffic deaths.','D. Safety advocates are desperately searching for slow drivers.'),NULL,NULL,2,'answerable'),
(@pid,22,19,'choice','Part Ⅱ Reading Comprehension · Section A','What is Jonathan Adkins’ attitude toward installing speed cameras?',JSON_ARRAY('A. Critical','B. Intolerant','C. Sympathetic','D. Unconcerned'),NULL,NULL,2,'answerable'),
(@pid,23,20,'choice','Part Ⅱ Reading Comprehension · Section A','According to Laura Friedman, automated cameras are used to _____.',JSON_ARRAY('A. sponsor the state law','B. collect more money for schools','C. let drivers respect the speed limit','D. improve the traffic flow in the city'),NULL,NULL,2,'answerable'),
(@pid,24,21,'choice','Part Ⅱ Reading Comprehension · Section A','In writing Paragraph 2, the author aims to _____.',JSON_ARRAY('A. give a definition','B. draw a conclusion','C. make a comparison','D. support a viewpoint'),NULL,NULL,2,'answerable'),
(@pid,25,22,'choice','Part Ⅱ Reading Comprehension · Section A','According to Paragraph 3, the ideal amount of sleep required each night _____.',JSON_ARRAY('A. can affect genes','B. is based on policies','C. is different from person to person','D. should be revised by public authorities'),NULL,NULL,2,'answerable'),
(@pid,26,23,'choice','Part Ⅱ Reading Comprehension · Section A','According to Paragraph 4, in the past, a person lacking sleep was probably regarded as _____.',JSON_ARRAY('A. an old person','B. an able person','C. a person creating strategies','D. a person making good use of his or her rest'),NULL,NULL,2,'answerable'),
(@pid,27,24,'choice','Part Ⅱ Reading Comprehension · Section A','According to the last paragraph, Dr.Shelby Harris thinks that _____.',JSON_ARRAY('A. rigid persons need longer sleep','B. a magic number can make you peaceful','C. good sleep habits can improve your sleep quality','D. drugs and technology are essential for a restless child'),NULL,NULL,2,'answerable'),
(@pid,28,25,'choice','Part Ⅱ Reading Comprehension · Section A','Where is the passage most probably taken from?',JSON_ARRAY('A. An essay on trade.','B. A report of public health.','C. A review of a sports event.','D. An introduction to an agency.'),NULL,NULL,2,'answerable'),
(@pid,29,26,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 26 题',JSON_ARRAY('A. The most important thing is to start slow.','B. What are the health benefits of jumping rope?','C. Jumping rope can also help people lose weight.','D. Regular practice of the sport strengthens muscles.','E. Non-running exercises can be beneficial for old people.','F. This simple piece of exercise equipment does not sell well.','G. The rope should be about 3 feet longer than your total height.'),NULL,NULL,3,'answerable'),
(@pid,30,27,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 27 题',JSON_ARRAY('A. The most important thing is to start slow.','B. What are the health benefits of jumping rope?','C. Jumping rope can also help people lose weight.','D. Regular practice of the sport strengthens muscles.','E. Non-running exercises can be beneficial for old people.','F. This simple piece of exercise equipment does not sell well.','G. The rope should be about 3 feet longer than your total height.'),NULL,NULL,3,'answerable'),
(@pid,31,28,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 28 题',JSON_ARRAY('A. The most important thing is to start slow.','B. What are the health benefits of jumping rope?','C. Jumping rope can also help people lose weight.','D. Regular practice of the sport strengthens muscles.','E. Non-running exercises can be beneficial for old people.','F. This simple piece of exercise equipment does not sell well.','G. The rope should be about 3 feet longer than your total height.'),NULL,NULL,3,'answerable'),
(@pid,32,29,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 29 题',JSON_ARRAY('A. The most important thing is to start slow.','B. What are the health benefits of jumping rope?','C. Jumping rope can also help people lose weight.','D. Regular practice of the sport strengthens muscles.','E. Non-running exercises can be beneficial for old people.','F. This simple piece of exercise equipment does not sell well.','G. The rope should be about 3 feet longer than your total height.'),NULL,NULL,3,'answerable'),
(@pid,33,30,'choice','Part Ⅱ Reading Comprehension · Section B','七选五 第 30 题',JSON_ARRAY('A. The most important thing is to start slow.','B. What are the health benefits of jumping rope?','C. Jumping rope can also help people lose weight.','D. Regular practice of the sport strengthens muscles.','E. Non-running exercises can be beneficial for old people.','F. This simple piece of exercise equipment does not sell well.','G. The rope should be about 3 feet longer than your total height.'),NULL,NULL,3,'answerable'),
(@pid,34,31,'essay','Part Ⅲ Translation','As the notion of aging changes, it is unnecessary for the elderly to worry too much about aging. They should have a positive outlook on life, for optimistic people are more likely to lead longer and healthier lives. Of course, a positive attitude does not come naturally to everyone. The elderly should change mindsets and imagine a brighter future. Section B (10 points) Directions: In this section, you should translate a passage from Chinese into English. You should write your answer on the ANSWER SHEET.',NULL,NULL,NULL,10,'reveal_only'),
(@pid,35,32,'essay','Part Ⅲ Translation','不久的将来，我们会走上工作岗位。不管从事何种工作，我们都要爱岗敬业，相信自己从事的是伟大 的事业。工作中要重视自己的职责，发挥独特的才能。如果全心全意地投入工作我们就会成功，生活就更 有意义。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,36,33,'essay','Part Ⅳ Writing','Suppose you are Li Hua. Write a letter to Chris, a foreign friend of yours, to introduce a creative cultural gift (文化创意礼品) made by yourself. Your letter should include: 1) a description of the gift. 2) the reasons for making the gift. You should write neatly on the ANSWER SHEET.',NULL,NULL,NULL,20,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 英语 2025 (34 题, published=1) · 山东英语解析·材料1·选择10·写作3·暂缺20·共34 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='英语' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material','Part Ⅰ Cloze（选词填空）','【Word Bank】
A. when B. how C. spends D. rarely E. stay F. physically G. passion H. done I. younger J. wise

points each, 15 points）
Directions: In this section, there is a passage with ten blanks. You are required to select one word for each blank
from a list of choices given in the box. Read the passage through carefully before making your choices. Each
choice in the box is identified by a letter. Please mark the corresponding letter for each choice on the ANSWER
SHEET. You may not use any of the words in the box more than once.
A.when B.how C.spends D.rarely E.stay
F.physically G.passion H.done I.younger J.wise
A man who is 92 years old is teaching others the secret of __1__ to live a long and healthy life. Ivan Pedley,
a retired toolmaker, plays table tennis twice a week and has no plans to Stop any time soon. He took up the sport
__2__ He was 14. Now, 78 years later , he is still playing.
Each time he usually __3__ three hours playing table tennis,.He often goes up against opponents who are
much __4__. Although he may have slowed down a bit overtime , he __5__ get knocked off the table and his
success at the sport is all about technique. He first found his __6__ for table tennis while he was a teenager and let
it go for a while in his 20s. Playing table tennis helps how to __7__ healthy. Continuing to play it well into his
senior years is the best thing he has ever __8__. It is __9__ of you to be active well remain connected to others
and take care of yourself both __10__ and mentally.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,1,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 1 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,3,2,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 2 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,4,3,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 3 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,5,4,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 4 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,6,5,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 5 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,7,6,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 6 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,8,7,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 7 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,9,8,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 8 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,10,9,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 9 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,11,10,'choice','Part Ⅰ Cloze（选词填空）','Cloze 第 10 空',JSON_ARRAY('A. when','B. how','C. spends','D. rarely','E. stay','F. physically','G. passion','H. done','I. younger','J. wise'),NULL,NULL,2,'answerable'),
(@pid,12,11,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,13,12,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,14,13,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,15,14,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,16,15,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,17,16,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,18,17,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,19,18,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,20,19,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,21,20,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,22,21,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,23,22,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,24,23,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,25,24,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,26,25,'choice','Part Ⅱ Reading Comprehension · Section A','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',2,'missing'),
(@pid,27,26,'choice','Part Ⅱ Reading Comprehension · Section B','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',3,'missing'),
(@pid,28,27,'choice','Part Ⅱ Reading Comprehension · Section B','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',3,'missing'),
(@pid,29,28,'choice','Part Ⅱ Reading Comprehension · Section B','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',3,'missing'),
(@pid,30,29,'choice','Part Ⅱ Reading Comprehension · Section B','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',3,'missing'),
(@pid,31,30,'choice','Part Ⅱ Reading Comprehension · Section B','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',3,'missing'),
(@pid,32,31,'essay','Part Ⅲ Translation','One summer night, I found that the entire sky above my head was a sea of stars. I enjoyed Seeing the beauty. I felt very small when I realized the hugeness of the universe. Yet, I also realized that I was a part of this universe . Then, my heart was filled with joy and happiness. Section B (10 points) Directions: In this section, you should translate a passage from Chinese into English. You should write your answer on the ANSWER SHEET.',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,32,'essay','Part Ⅲ Translation','音乐能让锻炼更有趣。锻炼时听音乐，可以提高我们的耐心、注意力和自我控制力，还可以改善我 们的情绪和减少焦虑。音乐能使我们更健康，更自信，更快乐。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,33,'essay','Part Ⅳ Writing','Suppose you are Li Hua,a student at Hongxing college. Write a letter to apply for membership of the International cultural Tourism Innovation Team. Your letter should include: 1) a brief self-introduction 2) the reasons for your application',NULL,NULL,NULL,20,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 政治 2025 (4 题, published=1) · 中文卷解析·选择0·材料0·主观4·暂缺0·共4 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='政治' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'essay','全文','简述中国共产党始终代表最广大人民群众的根本利益的内涵。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,2,1,'essay','全文','大学生如何正确选择择业观和创业观。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,3,2,'essay','全文','简述如何实现人类文明新形态。 材料分析题',NULL,NULL,NULL,5,'reveal_only'),
(@pid,4,2,'essay','全文','如何理解改革创新的内涵。',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 大学语文 2022 (40 题, published=1) · 中文卷解析·选择10·材料0·主观30·暂缺0·共40 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='大学语文' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','教育理念“有教无类”，是（ ）提出的。',JSON_ARRAY('A. 孔子','B. 孟子','C. 老子','D. 庄子'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','杜甫名句“笔落惊风雨，诗成泣鬼神”称赞的是（ ）。',JSON_ARRAY('A. 陶潜','B. 李白','C. 曹植','D. 苏轼'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','以下名句歌咏扬州风景的是（ ）。',JSON_ARRAY('A. 二十四桥明月夜，玉人何处教吹箫','B. 春风得意马蹄疾，一日看尽长安花','C. 丞相祠堂何处寻？锦官城外柏森森','D. 姑苏城外寒山寺，夜半钟声到客船'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','崔莺莺是名著（ ）中的主要人物。',JSON_ARRAY('A. 《桃花扇》','B. 《西厢记》','C. 《牡丹亭》','D. 《长生殿》'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','中国历史上，因道教文化闻名于世的大山是（ ）。',JSON_ARRAY('A. 四川峨眉山','B. 浙江普陀山','C. 山西五台山','D. 湖北武当山'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列鲁迅作品，成功塑造了农民形象的是（ ）。',JSON_ARRAY('A. 《铸剑》','B. 《一件小事》','C. 《故乡》','D. 《藤野先生》'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','冰心《繁星·春水》“创造新陆地的，不是那滚滚的波浪，却是它底下细小的泥沙。”此诗蕴含的哲理 与下列选项相同的是（ ）。',JSON_ARRAY('A. 不识庐山真面目，只缘身在此山中','B. 问渠那得清如许，为有源头活水来','C. 岁寒，然后知松柏之后凋也','D. 合抱之木，生于毫末，九层之台，起于累土'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列作家，属于“津味小说”小说代表的是（ ）。',JSON_ARRAY('A. 张炜','B. 迟子建','C. 冯翼才','D. 路遥'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','梁实秋在《滑竿》中说：“坐滑竿的人是人上人。”这句话运用的修辞手法是（ ）。',JSON_ARRAY('A. 双关','B. 拟人','C. 夸张','D. 比喻'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列外国文学作家及作品说法正确的是（ ）。',JSON_ARRAY('A. 文艺复兴是西方欧洲国家的一场反封建、反教会的运动','B. 莫泊桑《红与黑》的主人公于连通过个人奋斗和最终失败的经历，展现了法国王朝复辟时期的全貌，既 揭露复辟封建贵族的覆灭命运，也批判得势的大资产阶级的卑劣，以及与贵族、僧侣之间的斗争。','C. 《复活》中的第一句话是“幸福的家庭是相同的，不幸的家庭各有各的不同。”','D. 爱尔兰剧作家萧伯纳曾获得诺贝尔文学奖的作品是《伪君子》。 第Ⅱ卷 非选择题部分'),NULL,NULL,1,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','屈原的《离骚》中“长太息以掩涕兮，__________。”彰显了诗人忧国忧民，情系百姓的高尚品格。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','唐代诗人王维的名句“独在异乡为异客，每逢佳节倍思亲”中，“佳节”指的是中国传统节日中的 __________。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','宋代诗人__________的诗句“纸上得来终觉浅，绝知此事要躬行。”强调了实践的重要性。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','人们通常把中国古代长篇小说分为历史演义、英雄传奇、神魔小说和“描摹世态人情”的人情小说等几 类，产生于明代的《__________》，被认为是人情小说的开山之作。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','清代剧作家洪昇创作的《__________》是演绎唐明皇、杨玉环故事成就最高的戏剧作品。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,16,16,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','吴荪甫是茅盾长篇小说__________中的民族资本家形象。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,17,17,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','艾青《我爱这土地》中诗句“为什么__________，因为我对这土地爱得深沉”，表达了对祖国深沉的爱。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,18,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','魏巍在纪实散文《谁是最可爱的人》中，将__________誉为最可爱的人，赞颂了他们崇高的爱国主义、 英雄主义和国际主义精神。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,19,19,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','梁晓声的长篇小说__________刻画了周秉昆等平民子弟跌宕起伏的人生，被编成同名电视剧，2022 年 在央视热播。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,20,20,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','“让暴风雨来得更猛烈些吧”这句话出自苏联作家__________的散文诗《海燕》。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,21,21,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','赦之，以劝．事君者。（《鞌之战》） 劝：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,22,22,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','生丈夫．．，二壶酒，一犬。（《勾践灭吴》） 丈夫：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,23,23,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','愿大王少．留意，臣请奏其效。（《苏秦始将连横说秦》） 少：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,24,24,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','三窟已就．，君姑高枕为乐矣。（《冯谖客孟尝君》） 就：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,25,25,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','于是焉，河伯始旋其面目，望洋．向若而叹曰。（《秋水》） 洋：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,26,26,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','王者不却．众庶，故能明其德。（《谏逐客书》） 却：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,27,27,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','然尚恨．有阙者，不为许远立传，又不载雷方春事首尾。（《张中丞传后叙》） 恨：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,28,28,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','登斯楼也，则有去国．．怀乡，忧谗畏讥，满目萧然，感极而悲者矣。（《岳阳楼记》） 去国：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,29,29,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','童子莫对．，垂头而睡。（《秋声赋》） 对：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,30,30,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','孔子曰：“微管仲，吾其被．发左衽矣。”（《戊午上高宗封事》） 被：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,31,31,'essay','四、翻译题（第 31 题 3 分，第 32 题 3 分，第 33 题 4 分，共 10 分）','以若所为，求若所欲，犹缘木而求鱼也。（《齐桓晋文之事》）（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,32,32,'essay','四、翻译题（第 31 题 3 分，第 32 题 3 分，第 33 题 4 分，共 10 分）','余朝京师，生以乡人子谒余，撰长书以为贽，辞甚畅达。（《送东阳马生序》）（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','四、翻译题（第 31 题 3 分，第 32 题 3 分，第 33 题 4 分，共 10 分）','循是道也，虽传诸子孙世世，何不可之有？（《传是楼记》）（4 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,34,'essay','五、阅读分析题（本大题共 5 小题，共 20 分）','请分析“快”字的妙处及作用。（4 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,35,35,'essay','五、阅读分析题（本大题共 5 小题，共 20 分）','请简要分析尾联表达的作者的思想感情。（4 分） （二）现代文阅读（第 36 题 3 分，第 37 题 4 分，第 38 题 5 分，共 12 分） 林海雪原（节选） 曲波 杨子荣觉得不能在这多想，需马上回威虎厅，刚要回身，突然瞧见东山包下，大麻子出山的道路上走 来三个移动的人影。他的心突然一翻，努力凝视着走来的三个人，可是夜幕和落雪挡住了他的视线，怎么 也看不清楚。他再等一分钟，揉了揉眼睛，那三个人影逐渐地走近了，看清楚是两个小匪徒，押来一个人。 眼上蒙着进山罩，用一条树枝牵着。“这是谁呀？” 顿时千头万绪的猜测袭上他的心头。“是情况有变，剑波又派人来了吗？”“是因为我一个人的力量 单薄派人来帮忙吗？” “是孙达得路上失事，派人来告知我吗？”“这个被押者与自己无关呢，还是有关？” “是匪徒来投山吗？”“是被捉来的老百姓吗？是大麻子行劫带回来的俘虏吗？” 愈走近，他看被押来的那人的走相愈觉得眼熟，一时又想不起他到底是谁。他在这刹那间想遍了小分 队所有的同志，可是究竟这人是谁呢？ 得不出结论。 “不管与我有关无关，”他内心急躁地一翻，“也得快看明白，如果与自己有关的话，好来应付一切。” 想着，他迈步向威虎厅走来。当他和那个被押者走拢的时候，杨子荣突然认出了这个被押者，他立时大吃 一惊，全身怔住了，僵僵地站在那里。 “小炉匠，栾警尉，”他差一点喊出来，他全身紧张得像块石头，他的心沉坠得灌满了冷铅。“怎么 办？这个匪徒认出了我，那一切全完了。而且他也必然毫不费事；就能认出我，这个匪徒他是怎么来的呢？ 是越狱了吗？还是被宽大释放了？他又来干吗？” 他眼看着两个匪徒已把小炉匠押进威虎厅。他急躁地两手一擦脸，突然发现自己满手握着两把汗，紧 张得两条腿几乎是麻木了。他发觉了这些，啐了一口，狠狠地蔑视了一番自己，“这是恐惧的表现，这是 莫大的错误，事到临头这样的不镇静，势必出大乱子。”他马上两手一搓，全身一抖，牙一咬，马上一股 力量使他镇静下来。“不管这个匪徒是怎么来的，反正他已经来了！来了就要想来的法子。” 他的眉毛一皱，一咬下嘴唇，内心一狠，“消灭他，我不消灭他，他就要消灭我，消灭小分队，消灭 剑波的整个计划，要毁掉我们歼灭座山雕的任务。” 一个消灭这个栾匪的方案，涌上杨子荣的脑海，他脑子里展开一阵激烈的盘算：“我是值日官，瞒过 座山雕，马上枪毙他！”他的手不自觉地伸向他的枪把，可是马上他又一转念“不成！这会引起座山雕的 怀疑。那么就躲着他，躲到小分队来了的时候一起消灭。不成这更太愚蠢，要躲，又怎么能躲过我这个要 职司宴官呢？那样我又怎么指挥酒肉兵呢？不躲吧！见了面，我的一切就全暴露了！我是捉他的审他的人， 怎么会认不出我呢？一被他认出，那么我的性命不要紧，我可以一排子弹，一阵手榴弹，杀他个人仰马翻， 打他个焦头烂额，死也抓他几个垫肚子的。可是小分队的计划，党的任务就落空了。那么，怎么办呢？怎 么办呢？……” 他要在这以秒计算的时间里，完全作出正确的决定，错一点就要一切完蛋。他正想着，突然耳边一声 “报告”，他定睛一看，一个匪徒站在他的面前。 “报告胡团副，旅长有请。” 杨子荣一听到这吉凶难测的“有请”两字，脑子轰的一下像要爆炸似的激烈震动。可是他的理智和勇 敢，不屈的革命意志和视死如归的伟大胆魄，立即全部控制了他的惊恐和激动，他马上向那个匪徒回答道： “回禀三爷，说我马上就到！” 他努力听了一下自己发出来的声音，是不是带有惊恐？是不是失去常态？还不错，坦然，镇静，从声 音里听不出破绽。 他自己这样品评着。他摸了一下插在腰里的二十响，和插在腿上的一把锋利的匕首，一晃肩膀，内心 自语着：“不怕！有利条件多！我现在已是座山雕确信不疑的红人，又有‘先遣图’的铁证，我有置这个 栾匪于死地的充分把柄。先用舌战，实在最后不得已，我也可以和匪首们一块毁灭，凭我的杀法，杀他个 天翻地覆，直到我最后的一口气。”想到这里，他抬头一看，威虎厅离他只有五十余步了，三十秒钟后， 这场吉凶难卜、神鬼难测的斗争就要开始。他怀着死活无惧的胆魄，迈着轻松的步子，拉出一副和往常一 样从容的神态，走进威虎厅。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,36,36,'essay','五、阅读分析题（本大题共 5 小题，共 20 分）','杨子荣是一个怎样的人物形象，请简要概括其性格特点。（3 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,37,37,'essay','五、阅读分析题（本大题共 5 小题，共 20 分）','请分析杨子荣的心理变化。（4 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,38,38,'essay','五、阅读分析题（本大题共 5 小题，共 20 分）','请谈谈你从文章中得到的启示。（5 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,39,39,'essay','六、作文（本大题共 2 题，共 40 分）','根据所给情境和要求，完成应用文写作。 2022 年春季，在疫情封闭管理期间，丁一鸣等同学作为校园志愿者，成功完成各项任务。请为新华大 学学生处拟一篇表彰通报，号召大家向这些可爱的志愿者学习。 要求：信息齐全，格式规范，结构完整，语言得体。 （二）文学写作（30 分）',NULL,NULL,NULL,40,'reveal_only'),
(@pid,40,40,'essay','六、作文（本大题共 2 题，共 40 分）','阅读下面的材料，根据要求作文。 4 月 2 日，湖南长沙，袁隆平铜像在湖南省农科院揭幕。 铜像守望着他一辈子挂念的稻田，上面刻着“愿天下人都有饱饭吃”。 袁隆平夫人为袁隆平铜像献花，她所戴口罩上写着“人就像种子，要做一粒好种子”，让人泪目。 要求：请根据以上材料，自定立意，自拟题目，除诗歌外文体不限，不少于 800 字。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 大学语文 2023 (40 题, published=1) · 中文卷解析·选择10·材料0·主观30·暂缺0·共40 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='大学语文' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','以下名句属于先秦道家学派的是（ ）。',JSON_ARRAY('A. 知彼知己，百战不殆','B. 大直若曲，大巧若拙','C. 天下兼相爱则治；交相恶则乱','D. 君子周而不比，小人比而不周'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','杜甫在《蜀相》《八阵图》《咏怀古迹》诗中都提到一个人，这个人是（ ）。',JSON_ARRAY('A. 周瑜','B. 庞统','C. 司马徽','D. 诸葛亮'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','晚唐诗坛上，与温庭筠并称为“温李”，与杜牧并称为“小李杜”的诗人是（ ）。',JSON_ARRAY('A. 李之仪','B. 李商隐','C. 李贺','D. 李煜'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','古代把 24 小时分成 12 时辰，其中凌晨一点到三点属于（ ）。',JSON_ARRAY('A. 丑时','B. 寅时','C. 卯时','D. 辰时'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','以下诗句中，哪两句描绘的是春天的情景？（ ）。',JSON_ARRAY('A. 桃花细逐杨花落，黄鸟时兼白鸟飞','B. 忽如一夜春风来，千树万树梨花开','C. 月落乌啼霜满天，江枫渔火对愁眠','D. 梅子金黄杏子肥，麦花雪白菜花稀'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列属于“京派小说”作家的是（ ）。',JSON_ARRAY('A. 叶圣陶','B. 沈从文','C. 郁达夫','D. 张爱玲'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','以下女性人物中，出自《骆驼祥子》的是（ ）。',JSON_ARRAY('A. 虎妞','B. 四凤','C. 翠翠','D. 子君'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','与鲁迅“寄意寒星荃不察，我以我血荐轩辕”含意相似的诗句是（ ）。',JSON_ARRAY('A. 长风破浪会有时，直挂云帆济沧海','B. 千磨万击还坚劲，任尔东西南北风','C. 人生自古谁无死，留取丹心照汗青','D. 九死南荒吾不恨，兹游奇绝冠平生'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','食指的诗句“当蜘蛛网无情地查封了我的炉台，当灰烬的余烟叹息着沉重的悲哀”运用的修辞手法是（ ）。',JSON_ARRAY('A. 比喻','B. 比拟','C. 双关','D. 借代'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列说法正确的一项是（ ）。',JSON_ARRAY('A. 《一千零一夜》又名《天方夜谭》，是古希腊民间故事集','B. 法国巴尔扎克《高老头》中葛朗台是里面的吝啬鬼形象','C. 拉伯雷的《堂吉诃德》中主人公是一个喜剧形象','D. 日本第二个获得诺贝尔文学奖的作家是大川健三郎 第Ⅱ卷 非选择题部分'),NULL,NULL,1,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','曾子曰：“吾日三省吾身：为人谋而不忠乎？与朋友交而不信乎？__________？”',NULL,NULL,NULL,1,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','王安石的诗句“意态由来画不成，当时枉杀毛延寿”中提到的历史人物是西汉美女__________。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','中国佛教三大石窟分别为敦煌__________、云冈石窟、龙门石窟。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','王国维《人间词话》中曾提及“治学三境界”，其中第一重境界出自晏殊的《蝶恋花》：昨夜西风凋碧 树，独上高楼，__________。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','《我与地坛》的作者是__________。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,16,16,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','“四书”包括《论语》、《中庸》、__________、《孟子》。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,17,17,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','曹禺的“生命三部曲”包含的作品有《雷雨》、__________、《原野》。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,18,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','《流浪地球》的作者是__________，其因为《三体》获得“雨果奖”。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,19,19,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','诗句“生如夏花之绚烂，死如秋叶之静美”出自__________的《飞鸟集》。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,20,20,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','贺敬之的《回延安》运用了陕北民歌__________的艺术手法。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,21,21,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','同巷有王给谏者，相隔十余户，然素不相能．。（《小翠》） 能：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,22,22,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','夫子言之，于我心有戚戚．．焉。（《齐桓晋文之事》） 戚戚：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,23,23,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','如其礼乐，以俟．君子。（《子路、曾皙、冉有、公孙华侍座》） 俟：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,24,24,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','而后乃今培．风。（《逍遥游》） 培：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,25,25,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','天下云集响应，赢．粮而景从。（《过秦论》） 赢：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,26,26,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','间．命工斫木为橱，贮书若干万卷，区为经史子集四种。（《传是楼记》） 间：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,27,27,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','群臣吏民能面刺．寡人之过者，受上赏。（《邹忌讽齐王纳谏》） 刺：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,28,28,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','多行不义必自毙，子姑．待之。（《郑伯克段于鄢》） 姑：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,29,29,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','顷缘宰相无识，遂举以使虏。专务诈诞，欺罔天听，骤．得美官，天下之人切齿唾骂。（《戊午上高宗封 事》） 骤：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,30,30,'essay','三、释词题（本大题共 10 小题，每小题 1 分，共 10 分）','肉食者鄙．，未能远谋。（《曹刿论战》） 鄙：',NULL,NULL,NULL,1,'reveal_only'),
(@pid,31,31,'essay','四、翻译题（第 31 题 3 分，第 32 题 3 分，第 33 题 4 分，共 10 分）','人之有道也，饱食、暖衣、逸居而无教，则近于禽兽。（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,32,32,'essay','四、翻译题（第 31 题 3 分，第 32 题 3 分，第 33 题 4 分，共 10 分）','若此者甚众，皆崩崖所陨，致怒湍流，故谓之新崩滩。（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','四、翻译题（第 31 题 3 分，第 32 题 3 分，第 33 题 4 分，共 10 分）','项伯乃夜驰之沛公军，私见张良，具告以事，欲呼张良与之俱去。（4 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,34,'essay','五、阅读题（本大题共 20 分）','诗歌中，作者是如何化用王维的诗句“行到水穷处，坐看云起时”的，取得了怎样的表达效果。（4 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,35,35,'essay','五、阅读题（本大题共 20 分）','简析“青山无限好，犹道不如归”表达的情感。（4 分） （二）现代文阅读（第 36 题 3 分，第 37 题 4 分，第 38 题 5 分，共 12 分） 长街短梦 铁凝 ①有一次在邮局寄书，碰见从前的一个同学。多年不见了，她说咱们俩到街上走走好不好，于是我们 漫无目的地走了起来。 ②她之所以希望我和她在大街上走，是想告诉我，她曾经遭遇过一次不幸：她的儿子患白喉病死了， 死时还不到四岁。没有了孩子的维系，又使本来就不爱她的丈夫很快离开了她。这使她觉得羞辱，觉得日 子是再无什么指望。她想到了死。她乘火车跑到一个靠海的城市，在这城市的一个邮局里，她坐下来给父 母写诀别信。这城市是如此的陌生，这邮局是如此的嘈杂，无人留意她的存在，使她能够衬着这陌生的嘈 杂，衬着棕色桌面上糨糊的嘎巴和红蓝墨水的斑点把这信写得无比尽情——一种绝望的尽情。这时有一位 拿着邮包的老人走过来对她说：“姑娘，你的眼好，你帮我纫上这针。”她抬起头来，跟前的老人白发苍 苍，他那苍老的手上，颤颤巍巍地捏着一枚小针。 ③我的同学突然在那老人面前哭了。她突然不再去想死和写诀别的信。她说，就因为那老人称她“姑 娘”，就因为她其实永远是这世上所有老人的“姑娘”，生活还需要她，而眼前最具体的需要便是她帮助 这老人纫上针。她甚至觉出方才她那“尽情的绝望”里有一种做作的矫情。 ④她纫了针，并且替老人针脚均匀地缝好邮包。她离开邮局离开那靠海的城市回到自己的家。她开始 了新的生活，还找到了新的爱情。她说她终生感激邮局里遇到的那位老人，不是她帮助了他，那实在是老 人帮助了她，帮助她把即将断掉的生命续接了起来，如同针与线的连接才完整了绽裂的邮包。她还说从此 日子里有了什么不愉快，她总是想起老人那句话：“姑娘，你的眼好，你帮我纫上这针。”她常常在上班 下班的路上想着这话，在街上，路过一些熟悉或者不熟悉的邮局。有时候这话如同梦一样地不真实，却又 真实得不像梦。 ⑤然而什么都可能在梦中的街上或者街上的梦中发生，即使你的脚下是一条踩得烂熟的马路，即使你 的眼前是一条几百年的老街，即使你认定在这条老路上不再会有新奇，但该发生的一切还会发生，因为这 街和路的生命其实远远地长于我们。 ⑥我们曾经在公共汽车上与人争吵，为了座位，为了拥挤的碰撞。但是永远也记不住那些彼此愤怒着 的脸。记住的却是夹在车缝里的一束小黄花。那花朵是如此的娇小，每一朵才指甲盖一般大。是谁把它们 采来——从哪里采来又为什么要插在这公共汽车的窗缝里呢？怨气冲天的乘客实在难以看见这小小花束 的存在，可当你发现了它们才意识到胸中的怒气是多么的没有必要，才恍然悟出，这破旧不堪的汽车上， 只因有了这微小的花，它行驶过的街道便足可以称为花的街了。 ⑦假若人生犹如一条长街，我就不愿意错过这条街上每一处细小的风景。假若人生不过是长街上的一 个短梦，我也愿意把这短梦做得生意盎然。',NULL,NULL,NULL,20,'reveal_only'),
(@pid,36,36,'essay','五、阅读题（本大题共 20 分）','为什么老妇人说了“姑娘，帮我纫上这针”后，同学放弃了自杀？（3 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,37,37,'essay','五、阅读题（本大题共 20 分）','赏析文章划线的句子。（4 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,38,38,'essay','五、阅读题（本大题共 20 分）','试分析叙议结合的写作手法及其作用。（5 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,39,39,'essay','六、作文（本大题共 2 题，共 40 分）','根据所给情境和要求，完成应用文写作。 ××大学书画协会拟向全体会员于 4 月 28 日举办“画说校园”写生活动。 请你替协会会长拟一份通知。 （二）文学写作（30 分）',NULL,NULL,NULL,40,'reveal_only'),
(@pid,40,40,'essay','六、作文（本大题共 2 题，共 40 分）','阅读下面的文字，根据要求作文。 【材料一】君子安而不忘危，存而不忘亡，治而不忘乱，是以身安而国可保也。 ——欧阳修《新唐书·魏征传》 【材料二】安者非一日而安也，危者非一日而危也，皆以积渐然，不可不察也。 ——《周易》 【材料三】臣闻开拨乱之业，其功既难；守已成之基，其道不易。故居安思危，所以定其业也；有始 有卒，所以崇其基也。 ——《贞观政要》 根据以上材料，选取角度，自拟题目，写一篇不少于 800 字的文章；文体不限，诗歌除外。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 大学语文 2024 (40 题, published=1) · 中文卷解析·选择10·材料0·主观30·暂缺0·共40 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='大学语文' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','我国古代把请人作文章，书画所支付的酬劳称为（ ）。',JSON_ARRAY('A. 润例','B. 润文','C. 润笔','D. 润辞'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列事件或场景发生在宋代的是（ ）。',JSON_ARRAY('A. 赵孟頫创作的《鹊华秋色图》','B. 滕子京重修岳阳楼','C. 老秀才在学堂教读八股文','D. 《宋史》编纂完成'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列作品集，作者是王安石的是（ ）。',JSON_ARRAY('A. 《剑南诗稿》','B. 《稼轩长短句》','C. 《临川先生》','D. 《饮冰室文集》'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列诗句中反映作者离开家乡时间最长的是（ ）。',JSON_ARRAY('A. 离家当日尚炎风，叱驭归时九月穷','B. 十年旧梦无寻处，几度新春不在家','C. 走马西来欲到天，辞家见月两回圆','D. 少小离家老大回，乡音无改鬓毛衰'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列有关中国古代文学文化表述错误的一项是（ ）。',JSON_ARRAY('A. 庄子的文章想象奇特，文笔变化多端，多采用寓言故事形式，富有幽默讽刺的意味，对后世文学语言产 生了很大影响。','B. 关汉卿杂剧《窦娥冤》有台词：“行医有斟酌，下药依《本草》”。其中“本草”指的是李时珍的《本 草纲目》。','C. 古人在竹简上写字，写前用火烤去青竹简的水分，以便书写和防虫蛀，这道工序称为“杀青”。后用“杀 青”泛指写定著作。','D. 古人以山之南为“阳”，山之北为“阴”，水之南为“阴”，水之北为“阳”。如“华阴”在华山之北， “江阴”在长江之南。'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','韩少功提出作家要“释放现代观念的热能”，来重铸和镀亮“民族的自我”，其代表作《爸爸爸》所属 的文学流派是（ ）。',JSON_ARRAY('A. 寻根文学','B. 伤痕文学','C. 反思文学','D. 先锋文学'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','创造了中国农民读者喜闻乐见的评书体现代小说形式的作家是（ ）。',JSON_ARRAY('A. 臧克家','B. 赵树理','C. 周立波','D. 张恨水'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列出自郭沫若诗集《女神》的是（ ）。',JSON_ARRAY('A. 轻轻地我走了，正如我轻轻地来。','B. 西天还有些残霞，教我如何不想她。','C. 在雨的哀曲里，消了她的颜色，散了她的芬芳。','D. 啊啊！不断地毁坏，不断地创造，不断的努力哟！'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列中外文学形象，都属于悲剧人物的是（ ）。',JSON_ARRAY('A. 阿 Q、简爱、堂吉诃德','B. 三仙姑、浮士德、别里科夫','C. 孙少平、娜拉、安娜·卡列尼娜','D. 繁漪、哈姆莱特、普罗米修斯'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题：本大题共 10 小题，每小题 1 分，共 10 分。','下列关于外国文学的表述，完全正确的一项是（ ）。',JSON_ARRAY('A. 《钢铁是怎样炼成的》成功塑造了保尔·柯察金这一无产阶级英雄形象。','B. 巴尔扎克的长篇小说《追忆似水年华》是“意识流小说”的开山之作。','C. 米开朗琪罗、达·芬奇和川端康成被称为意大利“文艺复兴艺术三杰”。','D. 《海底两万里》的作者儒勒·凡尔纳被誉为“魔幻现实主义小说之父”。 第二部分 非选择题'),NULL,NULL,1,'answerable'),
(@pid,11,11,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','成语“汗牛充栋”形容藏书之多，其中，“栋”的意思是____________________。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,12,12,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','韩愈《古意》中“太华峰头玉井莲，开花十丈藕如船”两句使用了比喻和__________________。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,13,13,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','“不知江月待何人， 。”（张若虚《春江花月夜》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,14,14,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','欧阳修的词作《生查子》以“月上柳梢头，人约黄昏后”两句，描写了传统节日 的情景。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,15,15,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','古人称呼自己家属时，常用“家舍”等谦辞，如用“家严”，则指的是 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,16,16,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','鲁迅在《故乡》中塑造的从少年到中年变得麻木的形象是 （人物名）。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,17,17,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','“你是爱，是暖，是希望，你是人间的四月天。”这是诗人 的诗句。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,18,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','老舍的话剧 写了从清末民初到抗战胜利后北平沦陷区普通民众的生活与抗争。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,19,19,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','短篇小说《百合花》的作者 （作者名）通过对小通讯员和新媳妇两个人物的生动刻画， 展现出战争中人性的美。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,20,20,'fill','二、填空题：本大题共 10 小题，每小题 1 分，共 10 分。','法国浪漫主义作家雨果的长篇小说 （作品名）运用“美丑对照原则”来塑造人物。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,21,21,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','姜氏欲之，焉辟．害？（《郑伯克段于鄢》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,22,22,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','果行，国人皆劝．。（《勾践灭吴》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,23,23,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','丘也闻有国有家．者，不患寡而患不均，不患贫而患不安。（《季氏将伐颛臾》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,24,24,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','怒．而飞，其翼若垂天之云。（《逍遥游》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,25,25,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','权，然后知轻重；度．，然后知长短。（《齐桓晋文之事》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,26,26,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','五谷不登．，禽兽偪人。（《许行》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,27,27,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','奋六世之余烈，振长策．而御宇内。（《过秦论》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,28,28,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','君王为人不忍．，若入前为寿。（《鸿门宴》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,29,29,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','乌．有城坏其徒俱死，独蒙愧耻求活？（《张中丞传后叙》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,30,30,'essay','三、解释下列句子中加点词的意义：本大题共 10 小题，每小题 1 分，共 10 分。','夫人怒，奔女室，诟让．之。（《小翠》）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,31,31,'essay','四、将下列文言文翻译成现代汉语：本大题共 3 题，共 10 分。','下臣不幸，属当戎行，无所逃隐，且惧奔辟而忝两君。（《鞌之战》）（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,32,32,'essay','四、将下列文言文翻译成现代汉语：本大题共 3 题，共 10 分。','孟尝君怪其疾也，衣冠而见之，曰：“责毕收乎？来何疾也！”（《冯谖客孟尝君》）（4 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','四、将下列文言文翻译成现代汉语：本大题共 3 题，共 10 分。','“子卒也，而将军自吮其疽，何哭为？”（《孙子吴起列传》）（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,34,'essay','五、阅读分析题：本大题共 5 小题，共 20 分。','本诗描写了什么季节的景色？抒发了作者什么样的思想感情？（4 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,35,35,'essay','五、阅读分析题：本大题共 5 小题，共 20 分。','简要说明颔联“潮平两岸阔，风正一帆悬”的含义。（4 分） （二）阅读下面这篇文章，回答 36~38 题。（共 12 分） 看画 老舍 ①在穷苦中，偶尔能看到几幅好画，精神为之一振，比吃了一盘白斩鸡更有滋味！幸福得很，这次一 入城便赶上了可染兄的画展，——岂止几幅，三间大厅都挂满了好画啊！ ②在五年前吧，文艺协会义卖会员们的书画，可染兄画了一幅水牛，一幅山水，交给了我。这两张我 自己买下了，那幅水牛今天还在我的书斋兼客厅兼卧室里悬挂着。我极爱那几笔抹成的牛啊！ ③昨天去看可染兄的画展，我足足地看了两个钟头。他的画比五年前进步了不知有多少！五年前，他 仿佛还是在故意地大胆涂抹，使人看到他的胆量，可不一定就替他放心，——他手下有时候迟疑不定，今 天，他几乎没有一笔不是极大胆的，可是也没有一笔不是“指挥若定”了的。他的画已完全是他自己的了， 而且绝不叫观者不放心。 ④他的山水，我以为，不如人物好。山水，经过多少代的名家苦心创造，到今天恐怕谁也不容易一下 子就跳出老圈子去。可染兄很想跳出老圈子去，不论在用笔上，意境上，着色上，构图上，他都想创造， 不事模仿。可是，他只作到了一部分，因为他的意境还是中国田园诗的淡远幽静，他没有敢尝试把“新诗” 画在纸上。在这点上，他的胆气虽大，可是还比不上赵望云。凭可染兄的天才与工力，假若他肯试验“新 诗”，我相信他必会赶过望云去的。 ⑥望云也以画人物出名，可是，事实上，他并没画出人来。望云的人没有眼睛，没有表情。论画人物， 可染兄的作品恐怕要算国内最伟大的一位了。真的他没有像望云那样分神给人物换衣装，但是望云只能教 人物换上现代衣服，而没有创造出人。可染的人物是创造，他说那是杜甫那就是杜甫。他要创造出一个醉 汉，就创造出一个醉汉，——与杜甫一样可以不朽！可染兄真聪明，那只是一抹，或画成几条淡墨的线， 便成了人物的衣服；他会运用中国画特有的线条简劲之美，而不去多用心衣服是哪一朝哪一代的。他把精 神都留着画人物的脸眼。大体上说，中国画中人物的脸永远是在动的，像一块有眉有眼的木板，可染兄却 极聪明地把西洋画中的人物表情法搬运到中国画里来，于是他的人物就活了，他的人物有的闭着眼，有的 睁着一只闭着一只眼，有的挑着眉，有的歪着嘴，不管他们的眉眼是什么样子吧，他们的内心与灵魂，都 由他们的脸上钻出来，可怜的或可笑的活在纸上，永远活着！ ⑥在创造这些人物的时候，可染兄充分地表现了他自己的为人，——他热情，直爽，而且有幽默感。 他画这些人，是为同情他们，即使他们的样子有的很可笑。他的人物中的女郎们不像男人们那么活泼，恐 怕也许是尊重女性，不肯开小玩笑的关系吧？假如是这样，就不画她们也好，——创造出几个有趣的醉罗 汉或是永远酣睡的牧童也就够了！ （载一九四四年十二月二十二日重庆《扫荡报》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,36,36,'essay','五、阅读分析题：本大题共 5 小题，共 20 分。','谈谈你对文中第③段划线句子的理解。（4 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,37,37,'essay','五、阅读分析题：本大题共 5 小题，共 20 分。','简要分析倒数第二段是如何运用对比手法突出可染兄人物画成就的。（4 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,38,38,'essay','五、阅读分析题：本大题共 5 小题，共 20 分。','结合文本与生活实际，谈谈你从这篇文章中得到的启示。（4 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,39,39,'essay','六、写作题：本大题共 2 小题，共 40 分。','根据所给情景和要求，完成应用文写作。（10 分） 2023 年暑假，新华大学管理学院学生丁一鸣在某物流公司参加了为期 40 天的社会实践，请你以该物 流公司的名义，为丁一鸣拟一份社会实践证明。 要求：（1）信息齐全，格式规范，文体规范，语言得体。（2）文中不得出现与考生本人相关的信息如涉 及校名人名地名等，请使用××代替。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,40,40,'essay','六、写作题：本大题共 2 小题，共 40 分。','阅读下面的材料，根据要求作文。（30 分） 深空虽广阔，但踏过平庸，你终将成为最亮那颗星； 前路虽遥远，但笃定方向，你依然走在最优路线上。 以上材料对我们颇具启示意义。请结合材料写一篇文章，体现你的感想与思周考。要求：选准角度，确定 立意，明确文体，自拟标题；不套作，不得抄袭，不得透露个人信息；不少 800 字。',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 大学语文 2025 (40 题, published=1) · 中文卷解析·选择10·材料0·主观30·暂缺0·共40 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='大学语文' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','战国时期，主张依法治国，集法家思想之大成的是（ ）。',JSON_ARRAY('A. 荀况','B. 商鞅','C. 韩非','D. 苏秦'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','明代画家唐寅画诗：“满地风霜菊绽金，醉来还弄不弦琴。南山多少悠然趣，千载无人会此心。”这里 关联的古代文人是（ ）。',JSON_ARRAY('A. 谢灵运','B. 赵孟頫','C. 孟浩然','D. 陶渊明'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列古代文人，其别称与所任官职对应正确的是（ ）。',JSON_ARRAY('A. 李商隐——李翰林','B. 杜甫——杜工部','C. 柳宗元一一柳吏部','D. 王维——王右军'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列关于哪吒形象的表示，正确的一项是（ ）。',JSON_ARRAY('A. 哪吒是中国传统文化中极具代表性的神话人物形象，四川九寨沟有哪吒祖庙，民间祭祀活动盛行。','B. 明代长篇小说《西游记》详细叙述了哪吒灵珠子转世、闹海屠龙、莲花化身以及助周伐纣的故事。','C. 哪吒手持开山斧、脚踏七彩云的造型,是我国传统年画与雕塑等民间艺术的常见题材,象征着勇猛与正义。','D. 哪吒形象的来源和流传过程融合了宗教、文学和民间文化的多重影响，随着时代的变迁，其形象内涵不 断丰富。'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列关于中国传统文化常识表述正确的一项是（ ）。',JSON_ARRAY('A. 唐代书法家王羲之的《兰亭序集》是中国书法史、文学史和思想史的一座丰碑，被誉为“天下第一行书”。','B. 我国古代文人有名也有字，称呼对方一般用字，以表示敬意，自称则称名而不称字，这是古人严格遵守 的礼仪规范。','C. 古代礼制规定，女子到十五岁时要行“结发礼”即把头发盘成发髻，表示她已经到了可以婚嫁的年龄了。','D. 《水浒传》《金瓶梅》《儒林外史》《清明上河图》等文艺作品展现了北宋末年的历史事件和社会风貌。'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','九一八事变后从东北到内地的青年作家中，全部属于东北作家群的是（ ）。',JSON_ARRAY('A. 萧红、萧军、端木蕻良','B. 萧红、姚雪垠、萧军','C. 萧红、沙汀、骆宾基','D. 萧红、艾青、郁达夫'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','朱自清《浆声灯影里的秦淮河》：“电灯的光射到水上，蜿蜒曲折，闪闪不息，正如跳舞着的仙女的臂 膊。”这句话使用的修辞手法是（ ）。',JSON_ARRAY('A. 借代','B. 比喻','C. 拟人','D. 夸张'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列属于丁玲作品的是（ ）。',JSON_ARRAY('A. 《城南旧事》','B. 《生死场》','C. 《太阳照在桑干河上》','D. 《金锁记》'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','一生创作了七百多篇短篇小说，被誉为“世界短篇小说之王”的俄国作家是（ ）。',JSON_ARRAY('A. 果戈里','B. 莫里哀','C. 契诃夫','D. 欧·亨利'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','下列关于外国文学的表述，完全正确的一项是（ ）。',JSON_ARRAY('A. 英国作家莎士比亚的《威尼斯商人》对人性的贪婪和凶狠进行谴责。','B. 法国戏剧家易卜生的《玩偶之家》被称为“妇女解放运动的宣言书”。','C. 马尔克斯的小说《百年孤独》展现了非洲人民几个世纪的生活和奋斗史。','D. 印度诗人泰戈尔在 1913 年凭借抒情诗集《飞鸟集》获得了诺贝尔文学奖。 第Ⅱ卷 非选择题部分'),NULL,NULL,1,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','三国时期，孙权建立的吴国定都建业，建业是今天江苏省 市的古称。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','《洛神赋图》是东晋画家顾恺之读到三国文学家 写的《洛神赋》后有感而作。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','《左迁至蓝关示侄孙湘》：“云横秦岭家何在， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','传统京剧很多反映政治、军事斗争的剧目是根据历史小说改编的，如《华容道》、《群英会》就来源于 明代长篇小说 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','《红楼梦》第五回贾宝玉梦游太虚仙境警幻仙子用“万艳同杯”酒招待宝玉，这里“万艳同杯”使用的 修辞手法是 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,16,16,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','鲁迅笔下在咸亨酒店里“站着喝酒而穿长衫的唯一的人“是 ，他是被科举制度吞 噬的旧文人群体的缩影。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,17,17,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','繁漪是曹禺 1934 年发表的话剧 中的经典人物形象。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,18,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','老舍描写抗战时期沦陷区北平人民生活现状和思想面貌的长篇小说是 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,19,19,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','现代作家 的童话集《稻草人》给中国童话创作开辟了一条新的道路。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,20,20,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','被誉为“美国文学之父”的是 ，其代表作有《百万英镑》、《汤姆·索亚历险 记》等。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,21,21,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','不虞．君之涉吾地也，何故？（《齐桓公伐楚》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,22,22,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','若舍郑以为东道主，行李．．之往来，共其乏困，君亦无所害。（《烛之武退秦师》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,23,23,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','文公躬擐．甲胃，跋履山川，逾越险阻。（《吕相绝秦》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,24,24,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','贾人夏则资．皮，冬则资稀。（《勾践灭吴》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,25,25,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','明日徐公来，孰．视之，自以为不如。（《邹忌讽齐王纳谏》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,26,26,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','太后曰：“老妇恃．荤而行。”（《触龙说赵太后》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,27,27,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','今也滕有仓廪府库，则是厉民而以自养也，恶．得贤。（《许行》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,28,28,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','木直中．绳，輮以为轮，其曲中规。（《劝学》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,29,29,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','是以太山不让．土壤，故能成其大。（《谏逐客书》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,30,30,'essay','三、解释下列句子中加点词的意义（本大题共 10 小题，每小题 1 分，共 10 分）','巴人讼于孟涂之所，其衣有血者执．之。（《巫山巫峡》）（ ）',NULL,NULL,NULL,1,'reveal_only'),
(@pid,31,31,'essay','四、将下列文言文翻译成现代汉语（本大题共 3 题，共 10 分）','夫腹饥不得食，肤寒不得衣，虽慈母不能保其子，君安能以有其民哉？（《论贵粟疏》）（4 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,32,32,'essay','四、将下列文言文翻译成现代汉语（本大题共 3 题，共 10 分）','假令仆伏法受诛，若九牛亡一毛，与蝼蚁何以异？（《报任安书》）（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','四、将下列文言文翻译成现代汉语（本大题共 3 题，共 10 分）','匹夫见辱，拔剑而起，挺身而斗，此不足为勇也。（《留作关论》）（3 分）',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,34,'essay','五、阅读分析题（本大题共 5 题，共 20 分）','领联“溪霞晚红温，松日暮黄轻”描写了怎样的景色？（3 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,35,35,'essay','五、阅读分析题（本大题共 5 题，共 20 分）','这首诗传达出作者对秋日乡村生活怎样的感情？请结合全诗进行赏析。（5 分） （二）阅读下面这篇文章，完成 36-38 题。（共 12 分） 父亲进城 陈仓 ①接农民父亲进城，这是我家 2012 年春节期间发生的一场“革命”。 ②《百年孤独》里说，有一个死去的亲人埋在这片土地，就算是故乡了。但我却以为，是有一个至亲 之人，长期生活在身边，一起吃饭，一起睡觉，这便是故乡了。所以在异地他乡，年年都有接父亲进城的 动议，就是想让父亲把故乡带到一千三百公里之外。虽然父亲也是天天盼儿，但是故土对他而言，已经成 为生命的一部分了，让他离开故土等于要割他的肉。每次他都都会以“要喂猪”，或者是“麦子黄了”为 借口，不能动身。 ③母亲去世多年，而父亲近年身体异常糟糕，不是腰痛就是退肿，前不久还在砍柴的时候，从悬崖上 摔下去了。我害怕起来，如果有一天他突然不在了，至死也不知道流着他血脉的儿子如今在上海过的是什 么样的生活。如果在他有生之年，连他儿子住着什么，吃着什么，玩着什么，干着什么，统统都一无所知 的话，那将是我最大的遗憾。 ④突然接到姐姐的通知，父亲死活不愿意出山。我十分恼火，我真的不知道，在人生的最后时刻，有 什么比与儿子一起过年更重要的事情。父亲的理由还是一样，开春了，天暖了，砍了一些木头，要给香菇 木耳点菌；还要给麦子薅草，几亩坡地要种土豆了，等等。我让姐姐传话：一是告诉他，机票花了很多钱， 不能退，不能延期，如果不坐的话，就是废纸一张了，等于父亲十年的地白种了。父亲一生生活节俭到了 极点，就连撒泡尿，也要撒在自己家的玉米棵子底下，他不心疼？二是说我非常想他，房子已经装修了， 儿子在上海安家了，儿子的家就是他的家，他凭什么不来看看他的家呢？三是他若不来，说明他根本不想 儿子，那儿子也没必要整天牵肠挂肚，儿子就可以安心地待在上海，一辈子再也不回那个小村子了。 ⑤最后通牒还是有效果的一一他老泪纵横地决定，要来上海。但是初三晚上，当我与爱人双双飞到西 安，姐姐再次传话（每传一次话，都得跑几十里路，赶到有手机信号的地方），说是故乡在下大雪，已经 把几条路都封住了，根本没有办法出山。我又急又气：哪怕就是步行，也得走出大山，走到西安！ ⑥其实大雪是真下了，但是客车安上防滑链，就可以走盘山公路。说是大雪封山，仍是父亲一个借口。 正月初四早上，姐姐便把父亲送到了西安城，送到了我的身边。虽然需要使劲地大喊大叫才能让他听见， 但是毕竟可以与父亲面对面交流了。等我一声“爹”喊出口，我们父子都哭了。 ⑦父亲住在长江源头的深山老林，如今要来长江之尾的国际化大都市上海。他就像一滴水，先渗出一 条小溪，进入一条至今都没有名字的小河，然后再并入丹江，流入汉江，汇入长江，抵达东海。 ⑧2012 年春节期间，父亲终于进城了，由此产生的震动，不亚于滚滚长江所掀起的波浪。说实在的， 父亲进城其实就是一场革命，既是精神的，也是肉体的。 （摘自《花城》2012 年第 6 期，有删改》）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,36,36,'essay','五、阅读分析题（本大题共 5 题，共 20 分）','概括文中父亲的性格特征。（4 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,37,37,'essay','五、阅读分析题（本大题共 5 题，共 20 分）','“我”为什么急盼父亲进城？试从文中找出原因。（4 分）',NULL,NULL,NULL,20,'reveal_only'),
(@pid,38,38,'essay','五、阅读分析题（本大题共 5 题，共 20 分）','为什么说“父亲进城其实就是一场革命，既是精神的，也是肉体的”？请结合文体做简要分析。(4 分)',NULL,NULL,NULL,20,'reveal_only'),
(@pid,39,39,'essay','六、写作题（本大题共 2 题，共 40 分）','根据所给情景和要求，完成应用文写作。（10 分） 新华大学青年教师丁一鸣因购房需要，于 2025 年 2 月 15 日向同事事李金教授借款 5 万元并承诺两年 内全部还清，请你为丁一鸣代写一张借条。 要求:信息齐全，结构完整，格式规范，表达得体。',NULL,NULL,NULL,40,'reveal_only'),
(@pid,40,40,'essay','六、写作题（本大题共 2 题，共 40 分）','阅读下面的材料，根据要求作文。（30 分） 据报道，某博物馆要求壁画修复人员每天工作不超过三小时，以防手抖，而 AI 绘画，软件一秒就能 生成上千张敦煌“新天飞图”。有画家说：“我们这代人既要追赶上 5G 的速度，也要坚守古人磨墨的耐 心。” 以上材料对我们颇具启示意义。请结合材料写一篇文章，体现你的感悟与思考。 要求：选准角度，确定立意，明确文体，自拟标题；不要套作，不得抄袭；不得泄露个人信息；不少于 800 字。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 计算机 2022 (75 题, published=1) · 中文卷解析·选择30·材料0·主观35·暂缺0·共75 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='计算机' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','“存储程序和程序控制”原理的提出者是（ ）。',JSON_ARRAY('A. 比尔·盖茨','B. 史蒂夫·乔布斯','C. 艾伦·图灵','D. 冯·诺依曼'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','直接用二进制代码指令表达的计算机语言是（ ）。',JSON_ARRAY('A. 机器语言','B. 汇编语言','C. 智能语言','D. 高级语言'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于计算机特点和发展趋势的说法，错误的是（ ）。',JSON_ARRAY('A. 计算机具有强大的存储能力','B. 计算机巨型化是指计算机体积越来越大','C. 计算机具有运算速度快、自动执行、逻辑判断能力强等特点','D. 计算机智能化，是指计算机向模拟人的感觉和思维过程方面发展'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于总线的说法，错误的是（ ）。',JSON_ARRAY('A. 总线是计算机中数据传输的公共通道','B. 按照传输信号的不同，总线分为地址总线、数据总线和控制总线','C. 地址总线、数据总线和控制总线都是双向传输的','D. 总线的数据传输方式包括串行和并行'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列不属于算法表达方式的是（ ）。',JSON_ARRAY('A. 流程图','B. 伪代码','C. 自然语言','D. E-R 图'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于算法特性的描述，错误的是（ ）。',JSON_ARRAY('A. 算法的有穷性是指算法必须在执行有限个操作步骤后终止','B. 算法的确定性是指每一步的含义都不能有二义性','C. 算法的可行性是指算法描述的步骤在计算机上是可行的','D. 算法可以没有输出，但至少要有一个输入'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于Windows7 任务栏的说法，错误的是（ ）。',JSON_ARRAY('A. 可以通过任务栏启动任务管理器','B. 可以通过任务栏将打开的所有窗口最小化','C. 可以通过任务栏设置已打开应用程序的属性','D. 可以隐藏任务栏，也可以改变任务栏的位置'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于记事本应用的说法，错误的是（ ）。',JSON_ARRAY('A. 可以复制Word2010 文档中的一个表格到记事本','B. 可以复制Excel2010 工作表中的文字到记事本','C. 网页内容中只有文字可以复制到记事本','D. 在记事本中可设置文字的字体和字号'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Windows7 中，下列属于文件和文件夹常规属性的是（ ）。',JSON_ARRAY('A. 压缩','B. 隐藏','C. 系统','D. 共享'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','Word2010 文档中，要将“标题1”样式的内容全部删除，下列操作最优的是（ ）。',JSON_ARRAY('A. 选中“标题1”样式的某一内容，选择“选定所有格式类似的文本”，按Delete 键','B. 在“查找和替换”对话框，查找内容填“标题1”样式，替换为不填，点击“全部替换”','C. 按Ctrl 键，逐一点击“标题1”样式的内容，按Delete 键','D. 将“标题1”样式的内容手动逐一删除'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Excel2010 的单元格中输入“=2022-01-01”并回车，单元格中显示的是（ ）。',JSON_ARRAY('A. 2020','B. 2022-01-01','C. 2022 年1 月1 日','D. 2022-1-1'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','关于PowerPoint2010 视图方式的说法，错误的是（ ）。',JSON_ARRAY('A. 在普通视图的“幻灯片/大纲”窗格中可以编辑文字','B. 在备注页视图中可以对幻灯片内容与备注进行编辑','C. 在阅读视图中不能对幻灯片进行修改','D. 幻灯片浏览视图便于查看演示文稿中所有幻灯片的全貌'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','“出版社”实体与“书店”实体之间的联系是（ ）。',JSON_ARRAY('A. 一对一','B. 一对多','C. 多对一','D. 多对多'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','IPv4 中，IP 地址由32 位二进制数组成，分为A、B、C、D、E 五类，其中前三位为110 的是（ ）。',JSON_ARRAY('A. A 类','B. B 类','C. C 类','D. D 类'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于网络应用与服务的说法，错误的是（ ）。',JSON_ARRAY('A. FTP 不能传输图像文件和声音文件','B. 电子邮件系统最常用的协议是SMTP 和POP3','C. 搜索引擎使用网络爬虫和检索排序等技术','D. Telnet 是为远程用户之间建立连接而提供的一种服务'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在HTML 中，<title>和</title>标签用来定义（ ）。',JSON_ARRAY('A. 书签标题','B. 样式标题','C. 表格标题','D. 网页标题'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','2 分钟声音数据，采样频率为44.1kHz，量化位数为16 位，单声道，未压缩，下列存储 量计算方法，正确的是（ ）。',JSON_ARRAY('A. 44.1×1000×8×1×120/8 字节','B. 44.1×1000×8×2×120/8 字节','C. 44.1×1000×16×1×120/8 字节','D. 44.1×1000×16×2×120/8 字节'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于多媒体中视频的说法，错误的是（ ）。',JSON_ARRAY('A. 视频编码压缩的目的是为了提高视频质量','B. 视频的数字化过程包括采样、量化、编码和压缩','C. 视频长时间保存不会降低质量','D. 流媒体技术是视频点播的主流技术之一'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于计算机病毒的说法，错误的是（ ）。',JSON_ARRAY('A. 计算机病毒是一组计算机指令或程序代码','B. 计算机病毒只感染可执行文件','C. 计算机感染病毒后不一定马上发作','D. 计算机病毒的预防有硬件和软件两种方式'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列有关云计算的说法，错误的是（ ）。',JSON_ARRAY('A. 云计算是个虚拟的计算资源池','B. 云计算服务中由第三方提供商完全承载和管理的是私有云','C. 云计算具有高可靠性、按需服务、高可扩展性等特点','D. 云计算是一种按使用量付费的模式'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于计算机中字符编码的说法，正确的是（ ）。',JSON_ARRAY('A. 机内码用2 个字节编码，国标码用1 个字节编码','B. 计算机使用的中文字符编码包括输入码、国标码、机内码和字形码等','C. 汉字的字形码具有唯一性','D. ASCII 码最多可表示256 种字符'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列可作为计算机输出设备的是（ ）。',JSON_ARRAY('A. 扫描仪','B. 触摸屏','C. 音箱','D. U 盘'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于面向对象程序设计的说法，正确的是（ ）。',JSON_ARRAY('A. 类和对象是面向对象程序设计的核心概念','B. 类是对象的抽象，对象是类的实例','C. 面向对象程序设计具有封装、继承和多态等特点','D. 在面向对象程序设计中，类与类之间可以继承'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）Word2010 文档页面视图中的标尺，除了能够调整左缩进和右缩进，还能调整的是（ ）。',JSON_ARRAY('A. 左边距','B. 首行缩进','C. 行间距','D. 悬挂缩进'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）在Excel2010 中，可使用预定义好的格式快速格式化工作表的是（ ）。',JSON_ARRAY('A. 使用“样式”功能区“套用表格格式”','B. 使用“样式”功能区“单元格样式”','C. 使用“单元格”功能区“格式”','D. 使用“字体”功能区'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）在PowerPoint2010 中，下列关于幻灯片中动画和切换效果的说法，正确的是（ ）。',JSON_ARRAY('A. 通过“动画”→“预览”命令只能预览动画效果','B. 通过“切换”→“预览”命令只能预览切换效果','C. 对同一个对象可以设置多个动画','D. 幻灯片切换可以设置不同的持续时间'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）有关系S 和T，如图1 所示。由关系S 得到关系T 的关系运算是（ ）。',JSON_ARRAY('A. 选择','B. 投影','C. 连接','D. 笛卡尔积 关系S 关系T 学号 姓名 性别 联系方式 19001 张三 男 19905310099 19002 李四 男 19705440123 19003 王小五 女 19607372367 图1 学号 姓名 性别 19001 张三 男 19002 李四 男'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于计算机网络体系结构的说法，正确的是（ ）。',JSON_ARRAY('A. TCP/IP 是一个7 层的体系结构','B. 计算机网络体系结构的层次越多越好','C. 在OSI 参考模型中，物理层是最底层','D. 每一层都具有相对独立的通信功能，都为其上层提供服务'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于防火墙的说法，正确的是（ ）。',JSON_ARRAY('A. 防火墙主要检测系统内违背安全策略的行为','B. 防火墙不能够防范不通过它的连接','C. 防火墙能够对网络访问进行日志记录','D. 既有硬件防火墙也有软件防火墙'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列选项中能够体现大数据应用的有（ ）。',JSON_ARRAY('A. 广告精准推送','B. 系统个性化推荐','C. 智慧城市','D. 条形码'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）程序必须调入内存才能运行。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,32,32,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）BIPS 是描述计算机存储容量的指标。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,33,33,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）算法的时间复杂度与空间复杂度成正比。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,34,34,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）打开非模式对话框时仍可处理主程序窗口。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,35,35,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）列族数据库是一种非关系型数据库。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,36,36,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）网络的带宽与吐量成反比。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,37,37,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）统一资源定位符(URL)可以指向本地硬盘上的某个文件。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,38,38,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）MIDI 是一种数字音乐格式。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,39,39,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）网络信息安全面临的威胁与风险跟网络拓扑结构无关。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,40,40,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）RFID 是物联网的关键技术之一。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,41,41,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','CPU 一次存取、加工和处理的数据位数称为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,42,42,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','二进制数100010.01 对应的十六进制数为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,43,43,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','图2 所示流程图的输出结果是_____。 图2',NULL,NULL,NULL,1,'reveal_only'),
(@pid,44,44,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','Windows7 中，运行在内存中的程序称为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,45,45,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','从计算机中删除文件时，文件实际上暂时存储到_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,46,46,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','用于删除表中指定记录的SQL 命令是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,47,47,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','网络的有线传输介质中，抗干扰能力强，带宽高，传输损耗小，传输距离更长的是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,48,48,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','按照网络覆盖范围来分，一个单位的内部网络属于_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,49,49,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','多媒体系统对时序的要求，体现了多媒体技术特点中的_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,50,50,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','在对称密码体制和非对称密码体制中，可以公开一个密钥的是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,51,51,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','小王在主文档中插入页眉后，发现下方显示一条横线，要删除这条横线，下列操作可行 的是（ ）。 A.在页眉编辑界面，选定横线，按Delete 键 B.调整纸张大小 C.修改系统样式“页眉” D.修改页眉顶端距离',NULL,NULL,NULL,2,'reveal_only'),
(@pid,52,52,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要实现图4(1)所示效果，下列操作不可行的是（ ）。 A.设置环绕方式为“四周型” B.设置环绕方式为“上下型” C.设置环绕方式为“穿越型” D.设置环绕方式为“紧密型”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,53,53,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','下列操作能实现图4(2)所示效果的是（ ）。 A.设置文字效果 B.设置字体颜色 C.设置突出显示文本颜色 D.设置页面背景',NULL,NULL,NULL,2,'reveal_only'),
(@pid,54,54,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','实现图4(3)所示效果的最优操作是（ ）。 A.输入“诚挚邀请，敬候光临!”，设置字体格式 B.插入文本框，在文本框中输入“诚挚邀请，敬候光临!”，设置文本框形状样式 C.插入艺术字“诚挚邀请，敬候光临!”，并对艺术字进行设置 D.将“诚挚邀请，敬候光临!”制作为图片，插入后设置图片环绕方式',NULL,NULL,NULL,2,'reveal_only'),
(@pid,55,55,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','下列操作能实现图4(4)所示效果的是（ ）。 A.插入脚注 B.插入尾注 C.插入题注 D.插入批注',NULL,NULL,NULL,2,'reveal_only'),
(@pid,56,56,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要制作内容相同，收件人不同的邀请函。请从下列操作中选择，并依次写出序号_____。 ①点击“信封” ②点击“选择收件人” ③插入点定位至主文档“尊敬的”后，点击“插入合并域”→“姓名” ④点击“使用现有列表”选取数据源 ⑤点击“规则”，选择“如果…那么…否则”设置“性别”域规则 ⑥点击“规则”，选择“下一记录条件”→设置“性别”域规则 ⑦点击“完成并合并” ( 二 ) E x c e l 操 作 小谢是某高校财务部工作人员，他想利用Excel2010 做数据分析，已建立工作表，并 获取了部分数据(如图5 所示)，请结合所学知识回答下列问题。 图5',NULL,NULL,NULL,2,'reveal_only'),
(@pid,57,57,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','小谢希望将“基本工资”高于平均值的项标记出来，下列方法最优的是（ ）。 A.先使用average 函数计算平均值，然后手动标记 B.使用averageif 函数自动标记 C.使用if 函数自动标记 D.使用条件格式设置',NULL,NULL,NULL,2,'reveal_only'),
(@pid,58,58,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','需要将所有人员的“基本工资”增加15%，下列操作正确的是（ ）。 A.在一空白单元格输入1.15，复制该单元格，然后点击J3 单元格，使用“选择性粘贴”- “乘”，再双击J3 单元格右下角的填充柄 B.在一空白单元格输入1.15，复制该单元格，选中“基本工资”列全部数据单元格，使用 “选择性粘贴”-“乘” C.在J3 单元格输入“=J3*1.15”，确认后双击该单元格右下角的填充柄 D.在M3 单元格输入“=J3*1.15”，确认后双击该单元格右下角的填充柄，最后将M 列复 制后直接粘贴到J 列',NULL,NULL,NULL,2,'reveal_only'),
(@pid,59,59,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','根据“入职时间”在“工龄”列填入数据(满365 天计1 年)，下列操作正确的是（ ）。 A.在I3 单元格输入“=int((today（ ）-H3)/365)”，确认后双击该单元格右下角填充柄 B.在I3 单元格输入“=round((today（ ）-H3)/365，0)”，确认后双击该单元格右下角填充 柄 C.在I3 单元格输入“=year(today（ ）-year(H3))”，确认后双击该单元格右下角填充柄 D.在I3 单元格输入“=(today（ ）-H3)/365)”，确认后双击该单元格右下角填充柄，然后 通过设置单元格格式将1 列数据调整为保留0 位小数',NULL,NULL,NULL,2,'reveal_only'),
(@pid,60,60,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','需要按职称查询人员信息，下列方法最优的是（ ）。 A.先创建数据透视表，然后在数据透视表中查询 B.先设置条件区域，然后进行高级筛选，筛选出要查询的数据 C.先按“职称”进行排序，然后拖动窗口滚动条查询 D.先完成自动筛选，然后点击筛选标记选择要查询的职称',NULL,NULL,NULL,2,'reveal_only'),
(@pid,61,61,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','需要为“身份证号”列数据区域添加内容相同的批注，下列操作最优的是（ ）。 A.给E3 单元格添加批注，复制该单元格，选中其他单元格后执行“选择性粘贴-批注” B.给E3 单元格添加批注，复制该单元格，选中其他单元格后执行“选择性粘贴-格式” C.选择E 列数据区域，添加批注 D.给E 列数据区域逐一添加批注',NULL,NULL,NULL,2,'reveal_only'),
(@pid,62,62,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','为了比较不同职称人员的平均基本工资，创建如A 图6 所示的饼状图表，请从下列操作 中选择，并依次写出出序号_____。 图6 ①选择工作表数据区城，按“职称”排序 ②选择工作表数据区域，按“基本工资”排序 ③以“基本工资”为分类字段，求“基本工资”的平均值 ④以“职称”为分类字段，求“基本工资”的平均值 ⑤在汇总结果表中隐藏明细数据 ⑥选择汇总结果表，插入“饼图”，并做相关设置 ⑦选择汇总结果表中“职称”和“基本工资”两列的数据区城，插入“饼图”，并做相关 设置。 (三)PowerPoint 操作 小 陈 使 用 PowerPoint2010 制 作 了 如 图 7 所 示 的 演 示 文 稿 ，请 结 合 所 学 知 识 回 答 下 列 问 题 。 图7',NULL,NULL,NULL,2,'reveal_only'),
(@pid,63,63,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','在第1 张幻灯片中插入了音频文件，希望演示文稿放映时作为背景音乐全程播放，下列 操作最优的是（ ）。 A.在“音频工具播放”选项卡的“开始”列表中选择“自动(A)” B.复制粘贴音频文件到其他灯片中，逐个进行设置 C.在“音频工具播放”选项卡的“开始”列表中选择“跨幻灯片播放”，并选中“播完返 回开头” D.在“音频工具播放”选项卡的“开始”列表中选择“跨幻灯片播放”，并选中“循环播 放，直到停止”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,64,64,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','从第2 张幻灯片开始新增了标题为“内容”的节，希望该节的幻灯片切换方式一致，下 列操作最优的是（ ）。 A.为该节的幻灯片逐一设置切换方式 B.为该节的第1 张幻灯片设置切换方式 C.点击节标题，设置切换方式 D.为该节的最后一张幻灯片设置切换方式',NULL,NULL,NULL,2,'reveal_only'),
(@pid,65,65,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要为幻灯片填充“信纸”纹理，请从下列操作中选择，并依次写出序号_____。 ①打开“设置背景格式”对话框 ②选择“插入”选项卡中的“背景样式”按钮 ③选择“设计”选项卡中的“背景样式”按钮 ④选中“图片或纹理填充” ⑤打开“纹理”下拉式菜单，选中“信纸”，点击“重置背景”按钮 ⑥打开“纹理”下拉式菜单，选中“信纸”，点击“全部应用”按钮',NULL,NULL,NULL,2,'reveal_only'),
(@pid,66,66,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','发现合并后的数据有些数据行不可见，下列操作可以显示所有数据行的是（ ）。 A.选择整个工作表，在单元格格式设置中，取消隐藏工作表 B.选择整个工作表，在单元格格式设置中，点击“自动调整行高” C.选择整个工作表，在单元格格式设置中，点击“自动调整列宽” D.选择整个工作表，在单元格格式设置中，点击“锁定单元格”',NULL,NULL,NULL,1,'reveal_only'),
(@pid,67,67,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','小赵在当前工作簿中已建立结构和内容如图9 所示的“产品信息”表。使用vlookup 函 数，从“产品信息”表中查询产品的单价，填入“销售订单汇总表”中的对应列，在G3 单元格应输入的公式是（ ）。 图9 A.=vlookup($D$3,产品信息!$A1:$C9,3) B.=vlookup($D$3,产品信息!$A$1:$C$9,3) C.=vlookup(D3,产品信息!A$1:C$9,3) D.=vlookup(D3,产品信息!$A1:SC9,3)',NULL,NULL,NULL,1,'reveal_only'),
(@pid,68,68,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','需要统计不同产品的各销售分部的月销售情况(内容如图10 所示)。 图10 下列操作最优的是（ ） A.以“产品名称”和“分部名称”为行标签，以“日期”为列标签创建数据透视表 B.以“产品名称”和“分部名称”为列标签，以“日期”为行标签创建数据透视表 C.分别以“产品名称”、“分部名称”和“日期”为分类字段进行分类汇总 D.使用sumifs 函数分别填写各单元格数据 (二)小赵使用Word2010，为经理准备2021 年度销售总结报告。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,69,69,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','将图10 中的年度销售数据分析表插入到Word 文档中，希望Excel 文档中表格数据发生 变化时，Word 文档中的表格数据随之发生变化，下列操作方法最优的是（ ）。 A.在Word 文档中通过插入对象的方式插入需要的Excel 工作表 B.在Word 文档中通过插入表格的方式插入需要的Excel 工作表 C.将需要的Excel 工作表内容，以“选择性粘贴-链接与使用目标格式”的方式粘贴到Word 文档中 D.将需要的Excel 工作表内容，以“选择性粘贴-只保留文本”的方式粘贴到Word 文档中， 再将文本转换为表格',NULL,NULL,NULL,1,'reveal_only'),
(@pid,70,70,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','要将公司的Logo 图片作为文档背景，下列操作可以实现的是（ ）。 ①插入Logo 图片，将其环绕方式设置为“衬于文字下方” ②通过“页面背景”的“页面颜色”，将填充效果设置为Logo 图片 ③通过“页面背景”的“水印”，将Logo 图片设置为水印 ④通过“页面背景”的“页面边框”，将底纹设置为Logo 图片 A.①②③ B.③④ C.①②④ D.②③④',NULL,NULL,NULL,1,'reveal_only'),
(@pid,71,71,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','不允许修改文档中表格数据，下列操作方法最优的是（ ）。 A.为文档设置文件打开密码 B.选择表格后，设置保护密码 C.选择表格并执行剪切命令后，粘贴为图片 D.将文档保存为PDF 格式 (三)小赵使用PowerPoint2010 制作一份演示文稿，为经理年度总结汇报做准备。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,72,72,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','新建演示文稿后，由“年度销售总结报告”的文本内容生成幻灯片，下列操作最优的是 （ ）。 A.“文件”→“新建”→“根据现有内容新建” B.“开始”→“新建幻灯片”→“幻灯片(从大纲) C.“开始”→“粘贴”→“选择性粘贴”→“MicrosoftWord 文档对象” D.“插入”→“对象”→“由文件创建”',NULL,NULL,NULL,1,'reveal_only'),
(@pid,73,73,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','在演示文稿的所有幻灯片中都插入能够自动更新的时间，下列操作可以实现的是（ ）。 ①选中任意幻灯片，通过“插入”选项卡“文本”组中的“日期和时间”完成 ②进入幻灯片母版后，通过“插入”选项卡“文本”组中的“日期和时间”完成 ③选中任意幻灯片，插入文本框，直接在里面输入时间，然后进行复制粘贴 ④进入幻灯片母版后，通过“插入”选项卡“文本”组中的“页眉和页脚”完成 A.①②③④ B.①②③ C.②③ D.①②④',NULL,NULL,NULL,1,'reveal_only'),
(@pid,74,74,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','希望向不同对象演示时，根据需要调整幻灯片放映的数量或次序，但又不改变幻灯片在 演示文稿中的真正顺序，下列操作最优的是（ ）。 A.放映前根据需要对幻灯片进行删减 B.在“幻灯片/大纲”窗格中调整幻灯片的次序 C.在“自定义放映”对话框定义放映方案 D.针对不同需要，分别形成不同的演示文稿',NULL,NULL,NULL,1,'reveal_only'),
(@pid,75,75,'essay','六、综合运用题(本大题共 10 小题，每小题 1 分，共 10 分)','小赵把制作的各种文档保存在同一个文件夹内，希望将这个文件夹生成为一个压缩包， 下列操作一定会达到目的的是（ ）。 A.右击文件夹，利用快捷菜单中的“重命名”命令将扩展名改为压缩包文件扩展名 B.右击文件夹，利用快捷菜单中的“添加到压缩文件”命令完成 C.右击文件夹，利用快捷菜单中的“属性”命令完成 D.右击文件夹，利用快捷菜单中的“发送到”命令完成',NULL,NULL,NULL,1,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 计算机 2023 (70 题, published=1) · 中文卷解析·选择30·材料0·主观30·暂缺0·共70 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='计算机' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列属于ENIAC 采用的主要逻辑元件是（ ）。',JSON_ARRAY('A. 芯片','B. 晶体管','C. 电子管','D. 集成电路'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于计算机指令的说法。错误的是（ ）。',JSON_ARRAY('A. 指令是对计算机发出执行某种操作的命令','B. 指令和硬件有关','C. 指令一般包括操作码和地址码两部分','D. 指令必须经过编译后才能被计算机理解和执行'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列对于计算思维的说法。正确的是（ ）。',JSON_ARRAY('A. 计算思维是程序设计的思维','B. 计算思维是让人去模拟计算机的思维','C. 理论上可以计算的问题都可以用计算机解决','D. 计算思维是面向所有人的思维，而不是计算机科学家的专属思维'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于windows7 剪贴板的说法。错误的是（ ）。',JSON_ARRAY('A. 剪贴板是复制或移动信息时使用的临时存储空间','B. 剪贴板只能保存最后一次复制的信息','C. 剪贴板中的信息在“粘贴”命令使用后会消失','D. 按下 Printscreen 键后会将整个屏幕作为图像复制到剪贴板'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列说法中，不符合Windows7 操作系统特征的是（ ）。',JSON_ARRAY('A. 两个或两个以上正在运行的程序在同一时间间隔段内可同时运行','B. Windows7 中的资源可被并发执行的多个进程使用','C. Windows7内部产生的时间序列是确定的','D. Windows7 可以将一个物理实体映射成为若干个逻辑实体'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Word2010中下列操作无法删除整个表格的是（ ）。',JSON_ARRAY('A. 单击表格移动手柄选中整个表格后,报 Barkspace 键','B. 单击表格移动手柄选中整个表格后，按 Delete 键','C. 拖动鼠标选中表格所有单元格后。按Backspace 键','D. 拖动鼠标选中表格所有单元格后，在快捷菜单中选择“删除表格”'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','Word2010公式工具选项卡中描写错误的是（ ）。',JSON_ARRAY('A. 公式工具可以在“插入”选项卡，“对象”中启用','B. 可以在“公式工具/设计”选项卡中的结构中选择结构类型（如分数或根式）','C. 公式工具可以更改公式显示方式为“内嵌”或“显示”','D. 公式工具可以将编辑完成的公式存入公式库中以后使用'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在 Word2010中，图中文档所用的视图是（ ）。',JSON_ARRAY('A. 草稿视图','B. 大纲视图','C. Web版式','D. 阅读版式'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','关于Word2010 页眉的说法，错误的是（ ）。',JSON_ARRAY('A. 页眉可以插入页码','B. 页眉可以插入图片','C. 页眉位于文档顶部位置','D. 同一节中每页的页眉相同'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于Excel2010工作表页面设置的描述，错误的是（ ）。',JSON_ARRAY('A. 可以自定义起始页码','B. 不可以设置居中方式','C. 可以制定多个打印区域','D. 可以设置先打印列再打印行'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Excel2010 中，如果需要将工作薄AA 的工作表复制到工作薄 BB 中，下列正确的选 项是（ ）。',JSON_ARRAY('A. 只需要打开工作簿AA','B. 只需要打开工作薄BB','C. 工作薄AA 和BB 都打开','D. 都不需要打开工作薄AA 和BB'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在PowerPoint2010中，若要删除一张幻灯片，下列操作不可行的（ ）。',JSON_ARRAY('A. 在“普通视图”的“幻灯片/大纲”窗格中，右击要删除的幻灯片，选择“删除幻灯片”','B. 在“普通视图”的“幻灯片/大纲”窗格中，选中要删除的幻灯片，按 Delete 键','C. 在“幻灯片浏览”视图中，右击要删除的幻灯片，选择“删除幻灯片”','D. 在“阅读视图”视图中，右击要删除的幻灯片，选择“删除幻灯片”'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于PowerPoint 排练计时的说法错误的是（ ）。',JSON_ARRAY('A. 排练计时可以记录每张幻灯片的放映时长','B. 排练计时过程中不显示从开始放映到当前幻灯片所用的时间','C. 排练计时过程中，“录制”工具栏自动记录放映当前幻灯片已使用的时间','D. 选择“幻灯片放映”选项卡，在“设置”组中单击“排练计时”按钮，可开始排练计时'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于数据库的描述错误的是（ ）。',JSON_ARRAY('A. 属性的取值范围一般称为元组','B. 属性可看作二维表中的列','C. 一个关系可看作一张二维表','D. 主键的值唯一标识一个元组'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','SQL 中update的功能是（ ）。',JSON_ARRAY('A. 修改表结构','B. 修改表的数据','C. 删除表的数据','D. 删除表的属性'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列选项中，可用于WEB 浏览器和服务器通信且安全性更好的应用层协议是（ ）。',JSON_ARRAY('A. IP','B. HTML','C. HTTP','D. HTTPS'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','C 类地址网络的子网掩码为（ ）。',JSON_ARRAY('A. 255.0.0.0','B. 255.255.0.0','C. 255.255.255.0','D. 255.255.255.10'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','以下不属于流媒体的特点的是（ ）。',JSON_ARRAY('A. 保密性','B. 连续性','C. 时序性','D. 实时性'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于多媒体元素图形图像的描述正确的是（ ）。',JSON_ARRAY('A. 图像是矢量图，放大会失真','B. 图形是矢量图，放大会失真','C. 图形是矢量图，放大不失真','D. 图像是矢量图，放大不失真'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','若要按需分配资源(如 CPU，存储空间等)，为用户提供服务，下列计算机技术中最适合 采用的是（ ）。',JSON_ARRAY('A. 云计算','B. 大数据','C. 移动互联','D. 区块链'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）可用于衡量计算机性能的是（ ）。',JSON_ARRAY('A. 主频','B. 进制','C. 内核数','D. 运算速度'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列软件中属于应用软件的是（ ）。',JSON_ARRAY('A. 鸿蒙操作系统','B. 微信','C. 支付宝','D. Linux'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列选项中，能够通过 Windows7 控制面板实现的有（ ）。',JSON_ARRAY('A. 添加或删除用户帐户','B. 更改桌面背景','C. 卸载或更改程序','D. 打开或关闭 Windows 防火墙'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列选项中，可以作为 Windows7 中文件夹名的有（ ）。',JSON_ARRAY('A. Windows?','B. Windows/7','C. Windows7','D. Windows-7'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）关于 PowerPoint2010 中“换片方式”的描述正确的有（ ）。',JSON_ARRAY('A. 默认的换片方式为“单击鼠标时”','B. 若要使当前幻灯片放映 5 秒后自动切换到下一张，则可选中“设置自动换片时间”，且 将其属性值设置为“00:05.00”','C. 若同时选中“单击鼠标时”和“设置自动换片时间”，则在幻灯片放映过程中单击鼠标 时，将切换到下一张幻灯片','D. 若选中“设置自动换片时间”则属性值越大，当前幻灯片的切入速度越慢'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于非关系型数据库 (NOSQL)的描述正确的是（ ）。',JSON_ARRAY('A. 非结构化数据一般用 NOSQL 存储','B. NOSOL 和关系型数据库在数据规模、查询效率和扩展性等指标上各有优势','C. 关系型数据库有标准的 SQL，NOSQL 也有标准的查询语言','D. NOSQL 可以自由灵活的定义并存储冬种不同类型的数据'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于计算机网络体系结构的 OSI 参考模型和 TCP/IP 参考模型的描述，正确的是 （ ）。',JSON_ARRAY('A. TCP/IP 参考模型分为五层','B. OSI 参考模型分为七层','C. 两种参考模型都有传输层','D. TCP/IP 参考模型的网络接口层对应 OSI 参考模型的表示层和链路层'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）关于数字音频和图像的描述正确的是（ ）。',JSON_ARRAY('A. 音频的采样频率越高，声音质量越高，要求的存储量也越大','B. JPEG 格式的图像特点是文件小，压缩比可调整，不失真，可包含多幅静态图像','C. 同一段音频，其 MIDI 文件比波形文件大','D. 图像的相邻像素存在一定关系，是图像数据存在冗余的原因之一'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于非对称加密，正确的是（ ）。',JSON_ARRAY('A. 加密密钥和解密密钥相同','B. 使用两个密钥，一个公钥，一个私钥','C. 加密时，使用非对称加密比使用对称加密的速度快','D. 即使通过复杂的计算，也很难从公钥中推导出私钥'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于物联网的描述，正确的有（ ）。',JSON_ARRAY('A. 物联网是即互联网之后的一种全新的网络类型，二者相互独立','B. 物联网是大数据的重要来源之一','C. 云计算增强了物联网的数据存储和处理能力','D. RFID 技术，GPS 定位技术等都是物联网常用的技术'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）16 位二进制数码0011010001010011不是汉字的机内码。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,32,32,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）信息是存储在某种媒体上加以鉴别的符号资料，是数据的载体。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,33,33,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）扩展名为JPG 的文件不一定是图片文件。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,34,34,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）将文件夹设置为只读，则无法在此文件夹内新建文件。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,35,35,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）PowerPoint2010中，可以对幻灯片中插入的视频进行重新剪裁，并设置跨幻灯片 插放。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,36,36,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）数据库系统是数据库管理系统的核心。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,37,37,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）通常用宽带来描述计算机网络的数据传输速率，单位一般是HZ。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,38,38,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）数字图像的位深度(颜色深度)不影响该图像文件的大小。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,39,39,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）VPN 是基于公共网络建立的一个临时的，安全的连接，是对内网的扩展。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,40,40,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）区块链可以在缺乏信任的网络环境中建立信任。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,41,41,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','十进制数60转换为十六进制数为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,42,42,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','冯·诺依曼计算机的硬件系统由五大部分组成，其中整个计算机的指挥中心是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,43,43,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','Windows7 中在不同分区的两个文件夹之间进行拖动来移动文件，需按住键盘上的 _____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,44,44,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','Windows7 中，对计算机有完全访问权限，并可以对其他帐户进行更改的帐户类型是 _____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,45,45,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','PowerPoint2010 中，可将演示文稿另存为“PowerPoint 放映”类型的文件，该文件的 扩展名是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,46,46,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','SQL 中 Select 语句的 Where 子句体现的是关系运算中的_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,47,47,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','一个 IPv6 地址占用的字节数是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,48,48,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','在多媒体压缩技术中，按解压缩后的数据是否一致来分类，与原始数据一致的压缩方法 称为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,49,49,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','计算机病毒入侵计算机系统后，有的会降低计算机的工作效率，有的会删除文件。这些 情况体现了计算机病毒特点中的_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,50,50,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','数据包括文本，图片，音频，视频，日志，文档等数据类型，这体现了大数据特征中的 _____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,51,51,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要将作者姓名右边的数字设置为如图 3 所示的效果，下列操作可行的是（ ）。 A.选中数字，利用“字体”组中的“上标”进行设置 B.选中数字，利用“字体”组中的“下标”进行设置 C.选中数字，利用“字体”组中的“缩小字体”进行设置 D.选中数字，利用“字体”组中的“顶端对齐”进行设置',NULL,NULL,NULL,2,'reveal_only'),
(@pid,52,52,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','张三已对论文中一级标题应用了同一样式，现在要调整他们的段前间距为 20 磅，下列 方法最优的是（ ）。 A.使用“查找和替换”，替换原段前间距为 20 磅 B.修改样式中的段前间距为 20 磅 C.修改样式中的段前间距为 20 磅，并重新应用到一级标题 D.设置一个一级标题的段前间距为 20 磅，并利用格式刷将格式应用到其他一级标题',NULL,NULL,NULL,2,'reveal_only'),
(@pid,53,53,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要实现论文正文如图 3 所示两列显示的效果，下列操作可行的是（ ）。 A.选中正文，利用段落设置中的“分列”选项设置 B.选中正文，利用页面设置中的“分列”选项设置 C.选中正文，利用段落设置中的“分栏”选项设置 D.选中正文，利用页面设置中的“分栏”选项设置',NULL,NULL,NULL,2,'reveal_only'),
(@pid,54,54,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要在表格上方添加表的序号和标题，如图 3 所示的“表 1 标题”，应使用（ ）。 A.“引用”选项卡中的“插入表目录” B.“引用”选项卡中的“插入表注” C.“引用”选项卡中的“插入题注 D.“引用”选项卡中的“插入脚注”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,55,55,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','张三编辑论文时，发现某些文字下方出现了一些红色或绿色的波浪线，打印时看不到下 列选项中能产生该现象的是（ ）。 A.修订 B.校对 C.批注 D.比较',NULL,NULL,NULL,2,'reveal_only'),
(@pid,56,56,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','张三请李老师给予指导，希望能看到李老师对该论文所做的插入、删除等更改痕迹，从 初稿到根据李老师更改痕迹完成论文定稿，张三和李老师应采取的操作顺序是_____。 ①李老师对论文进行更改 ②张三或李老师启用“并排查看”功能 ③张三或李老师启用“修订”功能 ④张三使用“审阅”选项卡中的“校对”功能查看两文档的不同 ⑤张三接受或拒绝李老师所做的更改 (二)Excel 操作题 张老师负责学生奖学金评选工作。现已将学生档案表和五门课程的成绩表导入一个工 作簿的六个工作表中，“档案”表和“课程”表的结构分别如图 4a、4b 所示，其它四门 课程的表结构与“课程”表类似（仅课程名称不同）。奖学金评选条件为：五门课程的总 分排在全年级前 25%，并且每门课程成绩不低于 75 分。张老师要挑出符合奖学金评选条 件的学生并进行数据分析。请结合所学知识回答下列问题。 图4a 图4b',NULL,NULL,NULL,2,'reveal_only'),
(@pid,57,57,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','张老师在工作簿中新建了一个工作表“汇总”，想用“合并计算”将五门课程成绩汇总 到该工作表中，结果如 5a 所示，则在如图 5b 所示的“合并计算”对话框中“标签位置” 处应做的操作是（ ）。 A.只选中“首行” B.只选中“最左列” C.选中“首行”和“最左列” D.全部不选中',NULL,NULL,NULL,2,'reveal_only'),
(@pid,58,58,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','对“合并计算”得到的“汇总”表结构按实际需要调整后，如图 6 所示。现需要根据 “档案”表的数据(数据区域为 A1:C1012)使用 Vlookup() 函数填写“姓名”列数据，下 列操作可行的是（ ）。 A.在 B2 单元格输入“=vlookup(A2,档案!$A$1:$C$1012,2,0)”，拖动 B2 单元格填充柄向 下填充 B.在 B2 单元格输入“=vlookup(A2,档案!A1:C1012,2,0)”，拖动 B2 单元格填充柄向下填 充 C.在 B2 单元格输入“=vlookup(A2,档案!$A$1:C$1012,3,0)”拖动 B2 单元格填充柄向下 填充 D.在 B2 单元格输入“=vlookup(A2,档案!A1:C1012,3,0)”，拖动 B2 单元格填充柄向下填 充',NULL,NULL,NULL,2,'reveal_only'),
(@pid,59,59,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','现需要在“班级”列填入班级名如 (01 班，02 班等)，学号的第 7，8 位表示班级号， 下列操作正确的是（ ）。 A.在 C2 单元格输入 =Mid(A2,7,8)&“班”，拖动 C2 单元格填充柄向下填充 B.在 C2 单元格输入 =Mid(A2,7,8)+“班”，拖动 C2 单元格填充柄向下填充 C.在 C2 单元格输入 =Right(left(A2,8),2)&“班”，拖动 C2 单元格填充柄向下填充 D.在C2 单元格输入 =Right(left(A2,8),2)+“班”，拖动 C2 单元格填充柄向下填充',NULL,NULL,NULL,2,'reveal_only'),
(@pid,60,60,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要使用“替换”功能，将成绩为空的单元格填入文字“缺考”，在“查找和替换”对话 框中，下列操作正确的是（ ）。 A.“查找内容”不填，替换为填“缺考”，点击全部替换按钮 B.“查找内容”填””，替换为填“缺考”，点击全部替换按钮 C.“查找内容”填”0”，替换为填“缺考”，点击全部替换按钮 D.“查找内容”填 ”” or“0”，替换为填“缺考”，点击全部替换按钮',NULL,NULL,NULL,2,'reveal_only'),
(@pid,61,61,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','填入“总分”列数据，使用“自动缩选”筛选出“总分”排在前25%的数据并复制到工 作表中(结构同图 6 所示)。现要在新工作表中使用“高级筛选”功能从中筛选出每门课程 不低于 75 分的学生数据，下列条件区域设置正确的是（ ）。 A. B. C. D.',NULL,NULL,NULL,2,'reveal_only'),
(@pid,62,62,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要在高级筛选结果区域中，统计每个班级符合条件的人数，张老师应采取的操作，请从 下列操作中选择必要的顺序是_____。 ①选择整个数据区域，点击“数据”→“分类汇总 ②选择整个数据区域，点击“数据”→“排序” ③在“分类汇总”对话框中，分类字段选“班级”，汇总方式选“求和”，汇总项选“班 级”,点击“确定” ④在“分类汇总”对话框中，分类字段选“班级”，汇总方式选“计数”，汇总项选“班 级”，点击“确定” ⑤在“排序”对话框中，主要关键字选“班级”，点击“确定” ⑥在“排序”对话框中，主要关键字选“姓名”，点击“确定” (三)PowerPoint 操作题 齐老师要做专业建设汇报，使用 PowerPoint2010 制作了一个演示文稿，尚未进行母版背 景等设置，其中一张幻灯片如图 7所示。请结合所学知识回答下列问题。 图 7',NULL,NULL,NULL,2,'reveal_only'),
(@pid,63,63,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要在每张幻灯片的底部正中位置显示文字，“心系专业建设，培养应用型人才”，其中 张幻灯片的效果如图 8a 所示，下列方法最优的是_____。 图8a 图8b A.在每张幻灯片中添加文本框并输入要显示的文字 B.打开“视图”选项卡中的“幻灯片母版”视图，选择图 8b 所示左侧窗格中最上边的版 式，在右侧的编辑区添加文本框并输入要显示的文字 C.打开“视图”选项卡中的“幻灯片母版”视图，选择图 8b 所示左侧窗格中第 2 个以及 下边的任意一个版式，在右侧的编辑区添加文本框并输入要显示的文字 D.打开“设计”选项卡中的“幻灯片母版”视图，选择图 8b 所示左侧窗格中任意一个版 式，在右侧的编辑区添加文本框并输入要显示的文字',NULL,NULL,NULL,2,'reveal_only'),
(@pid,64,64,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','将演示文稿中如图9a 所示的幻灯片中的Smartart 图形修改为如图9b 所示的效果。选 中形状“试卷检查和“课程质量分析”，下列操作可行的是 （ ）。 图9a 图9b A.右击选中的形状，在快捷菜单中选择“降级” B.右击选中的形状，在快捷菜单中选择“下移” C.在“Smartart 工具/设计”选项卡中选择“降级” D.在“Smartart"工具/设计”选项卡中选择“下移”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,65,65,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','为了在放映幻灯片时，单击图8a 所示 ，能打开本机上的文件“课程体系 dcx”。 齐老师在编辑幻灯片时，应采取的操作顺序是 （ ）。 ①点击“插入”→“超链接”，选择 ②右击 ，选择“超链接” ③选中“现有文件或网页”后，找到文件“课程体系.docx”，点击“确定” ④选中“本文档中的位置”后，找到文件“课程体系.docx”，点击“确定”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,66,66,'essay','六、分析题(本大题共 5 小题，每小题 2 分，共 10 分)','如图 10 所示，请结合上图，分析出现上述情况的原因。 (二)赵老师使用 Exce12010 进行成绩分析,他对成绩进行了汇总以后，得到了一个如 图1la 所示的工作表,现在想利用“数据透视表”功能制作一个能完成简单查询的工作表， 选择班级时能够查询对应班级的学生的成绩，效果如图。 图11a 图11b 图12 (1) 在如图 11a 所示的工作表中选择数据区域单击“插入”→“数据透视表”，在弹出的 对话框中选择图“放置数据透视表的位置”为“新工作表”，单击“确定”后在新工作表 中显示如图 12 所示的“数据透视表字段列表”。 (2) 将“姓名”字段添加到“行标签”区域。 (3)将（ ）字段加到“报表选”区域，并通过“字段设置”将名称修改为“班级选择” (4)将“计算机”“数学”“外语”“总分”字段添加到（ ）区域 (5)得到图 11b 所示的成绩汇总工作表',NULL,NULL,NULL,2,'reveal_only'),
(@pid,67,67,'essay','六、分析题(本大题共 5 小题，每小题 2 分，共 10 分)','步骤(3) 中括号中的字段名称为_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,68,68,'essay','六、分析题(本大题共 5 小题，每小题 2 分，共 10 分)','步骤(4) 中括号内的字段名称为_____。 （三）刘老师班级里有 45 个学生，某次语文考试成绩存放在 S 中,s[i]表示第i 个学 生的成绩，（i=1，2，3，…45），为了编制计算机程序统计不及格(成绩小于 60) 的学生 人数(用C 表示)，刘老师画了流程图，如图 13，请结合图回答相应问题。 图13',NULL,NULL,NULL,2,'reveal_only'),
(@pid,69,69,'essay','六、分析题(本大题共 5 小题，每小题 2 分，共 10 分)','图 13 中①处应填_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,70,70,'essay','六、分析题(本大题共 5 小题，每小题 2 分，共 10 分)','C=C+1 的作用是_____。',NULL,NULL,NULL,2,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 计算机 2024 (69 题, published=1) · 中文卷解析·选择30·材料0·主观29·暂缺0·共69 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='计算机' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列（ ）设备电脑关闭电源后不丢失。',JSON_ARRAY('A. GPU','B. ROM','C. SDRAM','D. ALU'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','以下说法中错误的是（ ）。',JSON_ARRAY('A. 点阵码和矢量码是两种常见的汉字字形码','B. 半角、全角是同一字符的不同格式','C. 同一汉字字形码可能不同','D. 与ASCⅡ码存在冲突是国标码不能直接在计算机中使用的原因'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','关于多媒体和多媒体技术，下列选项正确的是（ ）。',JSON_ARRAY('A. 文本是多媒体元素','B. 多媒体技术只能处理数字信号，不能处理模拟信号','C. 多媒体计算机系统就是配备了声卡、显卡等多媒体设备的计算机','D. 多媒体数据压缩会导致信息丢失，因此压缩比越高，信息损失越多'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','关于算法说法错误的是（ ）。',JSON_ARRAY('A. 计算机算法是求解问题的方法和解决问题的步骤描述','B. 算法可以由不同的算法语言描述','C. 算法的优劣与算法描述语言无关','D. 算法需要编程实现后才能评价其优劣'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Windows7 中，下列选项中常用于删除临时文件、清空回收站并清除系统残留的是（ ）。',JSON_ARRAY('A. 系统还原','B. 磁盘清理','C. 磁盘扫描','D. 碎片整理'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于操作系统的叙述错误的是（ ）。',JSON_ARRAY('A. 操作系统的安全性主要是防止非法用户访问系统资源','B. 分布式操作系统可以管理分散在多个地理位置上的计算机资源','C. 实时操作系统对响应时间要求高','D. 操作系统的服务是一种后台运行的程序或进程，即提供对其他程序的支持'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Word2010 中，要选定从插入点至文档结尾的全部内容，应使用的组合键是（ ）。',JSON_ARRAY('A. Alt+End','B. Shift+End','C. Ctrl+Alt+End','D. Ctrl+Shift+End'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于Word2010 中表格的说法错误的是（ ）。',JSON_ARRAY('A. 可以将文本转换成表格','B. 可对列中的内容按照笔画顺序进行排序','C. 选中整个表格按Backspace 键可以清除表格内容，但不能删除表格','D. 可以在单元格中使用公式进行简单计算'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Word2010 中，下列需求不能用“查找和替换”实现的是（ ）。',JSON_ARRAY('A. 将指定文字替换为空','B. 删除所有空段落','C. 将嵌入式图片居中','D. 修改样式库中的样式'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Excel2010 中，下列关于“清除内容”命令描述正确的是（ ）。',JSON_ARRAY('A. 可以清除单元格的批注','B. 不能清除已设置的单元格格式','C. “清除内容”操作不能撤销','D. 数据型数据清除内容后显示为0'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在Excel2010 中编辑栏内输入“2*3”确认后活动单元格内容为（ ）。',JSON_ARRAY('A. 2','B. 3','C. 6','D. 2*3'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','在PowerPoint2010 中，要插入一张幻灯片，下列操作不可行的是（ ）。',JSON_ARRAY('A. 在“幻灯片/大纲”窗格中，右击要插入幻灯片的位置，使用“新建幻灯片”命令','B. 在“幻灯片浏览”视图中，单击要插入幻灯片的位置，用“开始”—“新建幻灯片”','C. 在“幻灯片/大纲”窗格中，单击要插入幻灯片的位置，按Ctrl+N','D. 在“幻灯片浏览”视图中，单击要插入幻灯片的位置，按Ctrl+M'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于PowerPoint2010 演示文稿放映过程的描述，错误的是（ ）。',JSON_ARRAY('A. 可以通过“屏幕—黑屏”命令暂停还未演示的内容','B. 可以通过“转到节”命令定位到节的任意一张幻灯片进行播放','C. 可以使用不同主题颜色或标准色的荧光笔','D. 不用结束演示文稿的放映就能切换程序'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','现有两个关系S 和关系T（属性相同）分别存储某班参加运动会100 米和400 米的学生 信息。下列运算关系中，能查询报名100 米但未报名400 米的选项的是（ ）。',JSON_ARRAY('A. S×T','B. S∪T','C. S∩T','D. S－T'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','某研究院要使用NoSQL 存储社交网络中人与人之间联系的海量数据。下列选项中，最 适合的是（ ）。',JSON_ARRAY('A. 文档数据库','B. 键值数据库','C. 图数据库','D. 列族数据库'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','小丽使用163 邮箱给小华的QQ 邮箱发了一封邮件，该邮件从163 邮件服务器投递到 QQ 邮件服务器，下列选项中，能实现这一功能的协议是（ ）。',JSON_ARRAY('A. SMTP','B. TELNET','C. POP3','D. FTP'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列选项中，不属于信息检索基本流程的是（ ）。',JSON_ARRAY('A. 确定检索要求','B. 选择检索数据库或检索源','C. 调整或优化检索策略','D. 为企业开发信息检索系统'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于布尔逻辑检索的描述，错误的是（ ）。',JSON_ARRAY('A. 使用布尔逻辑“与”可以提高检索的查准率','B. 使用布尔逻辑“或”可以提高检索的查全率','C. 布尔逻辑“与”的优先级低于“或”','D. 布尔逻辑“非”的优先级高于“与”'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于信息伦理说法，错误的是（ ）。',JSON_ARRAY('A. 引用他人观点时，可以根据自己的理解，随意表达','B. 引用别人正式发表的作品，需要征询对方同意','C. 信息发表以后，作者又出了修订版，应该以修订版为引用依据','D. 信息和知识的运用，不应该违背知识和法律'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 分，每小题 1 分。）','下列关于元宇宙的描述，错误的是（ ）。',JSON_ARRAY('A. 元宇宙、人工智能、虚拟现实等多种信息技术推动了元宇宙的发展','B. 利用元宇宙提供的数字化身，用户可以切换不同的身份，扮演多种角色','C. 依托区块链技术，个人隐私问题不再是元宇宙健康持续发展的关键','D. 元宇宙需要庞大的内容供给才能满足巨量用户在线沉浸式体验的需求'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）历代计算机采用的代表性主要逻辑元件包括（ ）。',JSON_ARRAY('A. 电子管','B. 晶体管','C. 继电器','D. 大规模、超大规模集成电路'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）关于存储程序工作原理正确的是（ ）。',JSON_ARRAY('A. 存储程序工作原理是冯·诺依曼提出的','B. 存储程序工作原理的基本思想是采用二进制','C. 存储程序工作原理是第四代计算机的基本工作原理','D. 存储程序工作原理是计算机能够自动完成运算或处理过程的基础'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列多媒体元素描述正确的是（ ）。',JSON_ARRAY('A. 图像可分为动态和静态图像','B. 图像的颜色深度影响图像文件的大小','C. MP3 和MP4 文件都属于音频文件','D. Flash 动画是数字视频的一种无损压缩方式'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于Windows7 任务管理器的描述，正确的有（ ）。',JSON_ARRAY('A. 可通过任务管理器禁用所有服务','B. 可通过任务管理器关闭正在运行的应用程序','C. 可通过任务管理器查看当前正在运行的程序','D. 可通过任务管理器查看系统资源使用情况'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于Windows7 实用程序的描述，正确的有（ ）。',JSON_ARRAY('A. 记事本不能设置文本颜色','B. 截图工具只能将截图保存为PNG 格式的文件','C. 计算器不能进行日期计算','D. 画图可以进行图像格式转换'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）PPT 中关于艺术字的说法正确的是（ ）。',JSON_ARRAY('A. 可以对艺术字进行任意角度旋转','B. 不能将艺术字转换为SmartArt 图形','C. 将两个艺术字组合后，还可以分别进行编辑','D. 可以对艺术字进行文本填充为纹理'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）关于数据库系统，下列描述正确的是（ ）。',JSON_ARRAY('A. 数据库系统的英文缩写是DB','B. 数据库管理员是数据库系统的一部分','C. 数据库系统就是数据库管理系统','D. 从数据管理技术角度出发，数据库系统相对文件系统数据共享性更高'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）关于信息检索，说法正确的是（ ）。',JSON_ARRAY('A. 信息检索能有效提高科学研究工作效率','B. 不同检索系统的具体检索流程可能有所不同','C. 信息检索能力是信息素养的组成部分','D. 信息检索就是计算机检索'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于信息技术说法正确的是（ ）。',JSON_ARRAY('A. 对于外国已有先进技术，完全没有必要自研','B. 加快信息技术应用创新，有利于我国技术良性发展','C. 关键核心技术自主可控是我国信息安全技术的安全保障','D. 北斗卫星导航系统是我国自主建设，独立运行的卫星导航技术，是我国自主创新的典范'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）ChatGPT 的应用场景包括（ ）。',JSON_ARRAY('A. 问答系统','B. 文本生成','C. 摘要生成','D. 语言翻译'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）所有十进制都可以精确转化为其他任意进制。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,32,32,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）对同一声音波形采样时，相同时间内，采样频率越高，获得的数据量越大。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,33,33,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Windows7 系统中卸载程序一定会删除程序的所有文件。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,34,34,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Windows7 系统中，可以通过“远程桌面连接”访问其他计算机。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,35,35,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在 PowerPoint2010 中，可以新建母版和版式，每个母版包含多个不同的版式。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,36,36,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）SQL 语句中deletefromstudentwhere 班级=“一班”的含义是从数据库student 中删除表名为“一班”的表。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,37,37,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）利用中国知网检索，一般情况下“模糊”检索比“精确”检索得到的结果数据量 多。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,38,38,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）一个大小为10MB 的文件，在传输速率为10Mbps 的网络上传输，理论上一秒即 可完成。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,39,39,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）只要安装了杀毒软件，就能确保计算机安全。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,40,40,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）区块链拥有中心结点，能防止单个结点伪装数据。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,41,41,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','计算机指令的组成部分中，说明操作种类的是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,42,43,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','在图像处理中，补偿图像轮廓，增强图像边缘，使图像变清晰的过程称为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,43,44,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','在 Windows7“开始”菜单中，能够帮助用户快速找到所需文件的是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,44,45,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','在 Windows7 中，专门用于管理计算机硬件设备的是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,45,46,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','PowerPoint2010 中通过“文件”选项卡设置打开演示文稿时视图方式为“幻灯片浏览” 时，首先应该使用“文件”选项卡的命令是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,46,47,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','对学生信息表增加“年龄”列，应该使用的SQL 命令是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,47,48,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','使用“光猫”上网，这种把光纤一直铺设到用户家庭的互联网接入方式是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,48,49,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','攻击者向文件服务器发送大量接收数据，导致文件服务器无法提供正常的服务。这种攻 击称为_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,49,50,'fill','四、填空题(本大题共 10 小题，每小题 1 分，共 10 分)','在物联网的三层体系中，负责采集物品及其周围环境的是_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,50,51,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','小红对正文进行了段落首行缩进2 字符的设置，但发现“荷花又被人誉为君子花”左边 并没有正确缩进，下列操作能修正的是（ ） A.在“荷花又被人誉为君子花”左边键入2 个空格 B.删除“荷花又被人誉为君子花”上边的符号⬇，再按Enter 键 C.选中该段落，在段落格式中设置悬挂缩进2 字符 D.选中该段落，在段落格式中设置首行缩进2 字符',NULL,NULL,NULL,2,'reveal_only'),
(@pid,51,52,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','“荷花，又名莲花、水芙蓉等”开头的段落的对齐方式最可能是（ ） A.两端对齐 B.居中 C.分散对齐 D.右对齐',NULL,NULL,NULL,2,'reveal_only'),
(@pid,52,53,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','正文中荷花图片的环绕方式一定不是（ ）。 A.四周型 B.紧密型 C.穿越型 D.嵌入型',NULL,NULL,NULL,2,'reveal_only'),
(@pid,53,54,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要修改插入页眉时页眉中自动产生的横线的颜色和宽度，下列方法可行的是（ ） A.双击页眉，在“边框和底纹”对话框的“页面边框”选项卡中设置“应用于”为“本节”， 并选中上框线进行颜色和宽度设置 B.双击页眉，在“边框和底纹”对话框的“页面边框”选项卡中设置“应用于”为“整篇 文档”，并选中上框线进行颜色和宽度设置 C.双击页眉，在“边框和底纹”对话框的“边框”选项卡中设置“应用于”为“段落”并 选中下框线进行颜色和宽度设置 D.双击页眉，在“边框和底纹”对话框的“边框”选项卡中设置“应用于”为“文字”并 选中下框线进行颜色和宽度设置',NULL,NULL,NULL,2,'reveal_only'),
(@pid,54,55,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要在页眉中右边的平行四边形（前期插入的形状）中插入页码，下列方法不可行的是（ ） A.将光标定位在平行四边形中，使用“插入”→“页码－页面顶端－普通数字” B.将光标定位在平行四边形中，使用“插入”→“页码－当前位置－普通数字” C.将光标定位在平行四边形中，使用“页眉和页脚工具/设计”→“页码－当前位置普通数 字” D.将光标定位在平行四边形中，使用“插入”→“文档部件－域”，并在域名中选中“Page”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,55,56,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','小红发现所有页眉中花卉名称均为荷花，她要使其他花卉内容从新的一页开始，并修改 页眉中的花卉名称，使其与所在页内容一致。应采取的操作（请从下列操作中选择必要的） 顺序是_____。 ①在各花卉内容起始处，使用“插入”→“分隔符－分页符”插入分页符 ②在各花卉内容起始处，使用“插入”→“分隔符－分节符（下一页）”插入分节符 ③在各花卉内容起始处，使用“页面布局”一“分隔符－分节符（下一页）”插入分节符 ④在各花卉页首页取消“链接到前一条页眉”，修改具有该条页眉的每页中的页眉文字 ⑤在各花卉页首页取消“链接到前一条页眉”，修改具有该条页眉的任一页的页眉文字 ⑥进入页眉编辑状态 （二）Excel 操作题 小军是某公司销售主管，收集了各分公司2023 年销售数据，使用Excel2010 整合到“销 售订单明细”工作表中，如图2 所示。请结合所学知识回答下列问题。 图 2',NULL,NULL,NULL,2,'reveal_only'),
(@pid,56,57,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要删除销售部门列中列“－”及其右边的内容，下方法最优的是（ ） A.在该列中逐个删除“－”及其右边的内容 B.选定该列，打开“查找和替换”对话框，查找内容输入“－*”，替换为不输入 C.选定该列，利用分列功能，以“－”为分隔符号分列，然后删除不需要的列 D.用 LEFT()函数获取“－”左边内容到空列，然后以值的方式粘贴到销售部门列',NULL,NULL,NULL,2,'reveal_only'),
(@pid,57,58,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','为了确保在浏览销售订单数据时，保持第2 行可见，下列操作可行的是（ ） A.单击第2 行行号，使用“视图”→“冻结窗格－冻结首行” B.单击第2 行行号，使用“视图”→“冻结窗格－冻结拆分窗格” C.单击第3 行行号，使用“视图”→“冻结窗格－冻结拆分窗格” D.单击第3 行行号，使用“视图”→“并排查看”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,58,59,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','在“销售订单明细”工作表中，插入了3 列（产品名称、销售单价、销售额），如图3 所示。为了美化数据区域，设置统一的外观并将其设为表格，则在选定数据区域后，下列 操作最优的是（ ） 图 3 A.单击“开始”→“套用表格格式”，选择一个适当的表样式 B.单击“开始”→“单元格样式”，分别选择适当的单元格格式 C.单击“开始”→“条件格式－新建规则”，新建一种格式规则 D.单击“开始”→“填充－系列”，设置一种自动填充方式',NULL,NULL,NULL,2,'reveal_only'),
(@pid,59,60,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要根据如图4 所示的“产品编号对照”工作表中的数据填充图3 所示的“销售单价”列 （若销量不少于20 件，单价降低5%），先填充H3 单元格，再根据其填入的公式自动填 充其他单元格，则H3 单元格应填入（ ） 图 4 A.=if(G3>=20,1,0.95)*vlookup(E3,产品编号对照!$A$3:$C$19,3,0) B.=if(G3>=20,1,0.95)*vlookup(E3,产品编号对照!A3:C19,3,0) C.=if(G3>=20,0.95,1)*vlookup(E3,产品编号对照!A3:C19,3,0) D.=if(G3>=20,0.95,1)*vlookup(E3,产品编号对照!$A$3:$C$19,3,0)',NULL,NULL,NULL,2,'reveal_only'),
(@pid,60,61,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','完成“销售订单明细”工作表中的数据填充后，要将2023 年各销售公司各季度的销售 额填充到如图5 所示“销售统计”工作表的对应单元格中，下列操作方法最优的是（ ） 图 5 A.在对应单元格中使用SUM()函数填充 B.在对应单元格中使用SUMIF()函数填充 C.在对应单元格中使用SUMIFS()函数填充 D.使用“分类汇总”功能，将汇总后的结果复制到对应单元格',NULL,NULL,NULL,2,'reveal_only'),
(@pid,61,62,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要将“销售订单明细”工作表中超过7 天后发货的订单信息行标记为红色，应采取的操 作（请从下列操作中选择必要的）顺序是_____。 ①单击“开始”→“条件格式” ②选择订单数据区域 ③选择“突出显示单元格规则－大于” ④选择“突出显示单元格规则－其他规则” ⑤在“新建格式规则”对话框中选择“使用公式确定要设置格式的单元格” ⑥在“为符合此公式的值设置格式”输入框中输入“=$C$3－$B$3>7”，单击“格式”按 钮设置字体颜色为红色后，单击“确定” ⑦在“为符合此公式的值设置格式”输入框中输入“=$C3－$B3>7”，单击“格式”按钮 设置字体颜色为红色后，单击“确定” （三）PowerPoint 操作题 李老师使用 PowerPoint2010 制作演示文稿介绍人工智能方面的知识，利用SmartArt 图形插入了目录，并为每条目录插入了超链接，如图6a 所示。请结合所学知识回答下列问 题。 图 6a',NULL,NULL,NULL,2,'reveal_only'),
(@pid,62,63,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','李老师不想看到超链接中的文本显示下划线和颜色改变，便取消了目录的超链接。现在 他要重新为每条目录插入超链接，下列方法正确的是（ ） A.分别定位于SmartArt 图形的每行文本中，插入超链接 B.分别单击 SmartArt 图形中每行文本的边框，插入超链接 C.分别选中 SmartArt 图形中每行文本，插入超链接 D.单击整个SmartArt 图形的边框，插入超链接',NULL,NULL,NULL,2,'reveal_only'),
(@pid,63,64,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','要插入图片文件将所有幻灯片的背景格式由图6a 设置为图6b 所示，且能够设定图片的 偏移量和透明度，下列方法最优的是（ ） 图 6b A.在普通视图中，使用“插入”→“对象” B.在普通视图中，使用“插入”→“图片” C.在普通视图中，使用“设计”→“背景样式” D.在幻灯片母版视图中，使用“设计”→“图片”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,64,65,'essay','五、操作题(本大题共 15 小题，每小题 2 分，共 30 分)','李老师插入了幻灯片编号后，希望首页（标题幻灯片版式）不显示编号，应采取的操作 （请从下列操作中选择必要的）顺序是_____。 ①单击“设计”→“页面设置” ②在“页眉和页脚”对话框的“幻灯片”选项卡中选中“标题幻灯片中不显示” ③在“页眉和页脚”对话框的“备注和讲义”选项卡中选中“标题幻灯片中不显示” ④单击“插入”→“幻灯片编号” ⑤单击“全部应用”',NULL,NULL,NULL,2,'reveal_only'),
(@pid,65,66,'essay','六、分析题(本大题共5 小题，每小题2 分，共 10 分)','出现上述的原因是______________________________。 （二）小勇为了预测 2024 年公司销售利润，使用Excel2010 设计了一个工作表，并获 取了 2023 年每日利润数据。请结合所学知识回答下列问题。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,66,67,'essay','六、分析题(本大题共5 小题，每小题2 分，共 10 分)','小勇要使用数据透视表功能得到各月份利润数据（如图8a 所示），他首先选择“日期” 为行标签，“利润（万元）”为求和项，创建了数据透视表（如图8b 所示），然后右击行 标签列中任一日期，在弹出的快捷菜单中（如图8c 所示）中，应选择的是_____。 图 8a 图 8b 图 8c',NULL,NULL,NULL,2,'reveal_only'),
(@pid,67,68,'essay','六、分析题(本大题共5 小题，每小题2 分，共 10 分)','小勇以数据透视表为数据源，插入了“利润”折线图并添加了趋势线（如图 9a 所示）， 要进行未来3 个月的销售利润趋势预测，他需要在如图9b 所示的“设置趋势线格式－趋势 线选项”的“趋势预测”区域进行的设置是_____。 图 9a 图 9b （三）小云要编制程序，对n 个购物网站同一种商品的价格从低到高进行排序。她绘制了 整个排序过程的流程图，其中一趟排序的流程图如图10 所示（a[i]表示价格序列中第i 个 值）。 注:一趟排序为从头到尾对价格序列中所有相邻的值进行比较，如果前大后小，则将其 交换。 请结合所学知识回答下列问题。 图 10',NULL,NULL,NULL,2,'reveal_only'),
(@pid,68,69,'essay','六、分析题(本大题共5 小题，每小题2 分，共 10 分)','图10 中①处应填入_____',NULL,NULL,NULL,2,'reveal_only'),
(@pid,69,70,'essay','六、分析题(本大题共5 小题，每小题2 分，共 10 分)','对价格序列(8,5,2,9,7,3)进行一趟排序后的结果_____。',NULL,NULL,NULL,2,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 计算机 2025 (60 题, published=1) · 中文卷解析·选择30·材料0·主观20·暂缺0·共60 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='计算机' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','一台微型计算机的某项性能指标为3.8GHz。这描述的是（ ）。',JSON_ARRAY('A. 硬盘','B. 内存','C. 微处理器','D. 声卡'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列字符编码中，不是汉字编码的是（ ）。',JSON_ARRAY('A. ASCII','B. GB18030','C. UTF-8','D. UTF-32'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列计算机软件中，不属于系统软件的是（ ）。',JSON_ARRAY('A. 统信UOS','B. Android','C. 抖音','D. 鸿蒙'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列关于计算思维的描述，错误的是（ ）。',JSON_ARRAY('A. 计算思维融合了数学、工程等其他领域的思维方式','B. 计算思维是计算机科学家的思维，可以使人类像计算机那样思考','C. 计算思维的本质是在不同层面进行抽象，以及将这样抽象自动化','D. 计算思维可以应用在计算机科学、机器学习、脑科学等领域'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列关于算法的描述，正确的是（ ）。',JSON_ARRAY('A. 算法至少一个输出','B. 算法不需要每个步骤都是确定的','C. 算法用伪代码表示后就可以直接被计算机执行','D. 算法只针对某个特定的问题，而不是一类问题'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','操作系统为了提高易用性，通常不会采取的措施是（ ）。',JSON_ARRAY('A. 提高简洁直观的图形化界面','B. 增加操作系统的复杂度','C. 提供丰富的系统帮助','D. 支持多语言'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','批处理操作系统的缺点是（ ）。',JSON_ARRAY('A. 支持多任务','B. 内存管理效率低','C. 无法处理I/O 操作','D. 交互性差'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','关于Windows10 窗口的说法，错误的是（ ）。',JSON_ARRAY('A. 双击标题栏可以使窗口最大化','B. 可通过窗口标题栏实现窗口的还原','C. 拖动窗口到屏幕底端可以实现窗口最小化','D. 拖动窗口到屏幕顶端可以实现窗口最大化'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列关于Windows10 任务栏搜索框，说法错误的是（ ）。',JSON_ARRAY('A. 可以隐藏','B. 可以仅显示搜索图标','C. 可以搜索Windows 应用','D. 只能搜索本地资源'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','在PowerPoint2016 演示文稿中，下列关于“节”的描述错误的是（ ）。',JSON_ARRAY('A. 可以复制节','B. 可以给默认节重命名','C. 可以同时折叠所有节','D. 可以通过“开始”选项卡新增节'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','关于数据库设计的说法，错误的是（ ）。',JSON_ARRAY('A. 设计E-R 图时，不用考虑具体使用的数据库管理系统','B. 确定数据的存储方法属于物理结构设计阶段的任务','C. 小型数据库开发不需要进行数据库设计','D. 需求分析是数据库设计必不可少的阶段'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','刘老师使用SQL 命令把2024 级新生记录添加到新生信息表应使用（ ）。',JSON_ARRAY('A. DELETE','B. SELECT','C. ALTER','D. INSERT'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','某大学的校园网已建成，要接入Internet，下列设备中必须要用到的是（ ）。',JSON_ARRAY('A. 网桥','B. 路由器','C. 交换机','D. 信号放大器'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','信息检索技术中使用截词检索可以（ ）。',JSON_ARRAY('A. 缩小检索范围','B. 提高查全率','C. 增加检索词的输入量','D. 减少检索结果'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列关于信息技术国产化的描述，错误的是（ ）。',JSON_ARRAY('A. 可以减少潜在的信息泄漏风险','B. 可以应对国外对我国的信息技术封锁','C. 有利于我国信息技术自主可控','D. 可以不遵循信息安全风险评估规范'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列关于计算机网络中防火墙的描述，正确的是（ ）。',JSON_ARRAY('A. 能够防止火灾','B. 能够阻止所有病毒入侵','C. 能够保护内网的安全','D. 能够防御所有网络攻击'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列关于云计算的描述，错误的是（ ）。',JSON_ARRAY('A. 服务扩展性差','B. 资源虚拟化','C. 按需服务','D. 安全性高'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','查看了大量监控视频后发现了一条有用的信息，这主要体现了大数据特征中的（ ）。',JSON_ARRAY('A. 处理速度快','B. 数据类型多','C. 价值密度低','D. 应用价值小'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','下列选项不属于区块链技术特征的是（ ）。',JSON_ARRAY('A. 去中心化','B. 交易不可否认','C. 透明可信','D. 防篡改性不可追溯'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分）','DeepSeek 大模型是人工智能技术的典型应用。下列关于DeepSeek 的说法，错误的是（ ）。',JSON_ARRAY('A. 是国内发布的大模型','B. 可以作为学习的辅助工具','C. 是一种开源的大模型','D. 生成的结果是完全可信的'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于电子数字积分计算机ENIAC 的描述，正确的是（ ）。',JSON_ARRAY('A. 属于第一代计算机','B. 以二进制作为运算基础','C. 采用了存储程序工作原理','D. 主要电子元件是电子管'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于存储容量单位的描述，正确的是（ ）。',JSON_ARRAY('A. 1PB=1024MB','B. 1GB=1024KB','C. 1KB=1024B','D. 1TB=1024GB'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于信息和数据的描述，正确的有（ ）。',JSON_ARRAY('A. 信息是数据的载体','B. 数据是信息的符号化','C. 信息是对数据进行加工后得到的结果','D. 从信息科学的角度看，小王体重是80 公斤，“80”是数据，“有点偏胖”是信息'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于面向对象程序设计思想和方法的描述，正确的有（ ）。',JSON_ARRAY('A. 采用了结构化程序设计','B. 引用了类和对象的概念','C. 利用对象实现数据和操作的封装','D. 对象之间的联系通过消息来传递'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于计算机程序基本结构的描述，正确的有（ ）。',JSON_ARRAY('A. “执行A，然后执行B”是顺序结构','B. “如果条件成立，那么执行A，否则执行B”是分支结构','C. 循环结构由循环体和循环终止条件构成','D. 顺序、选择、循环结构不能互相嵌套'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）Windows10 控制面板中项目的查看方式有（ ）。',JSON_ARRAY('A. 小图标','B. 大图标','C. 类别','D. 种类'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）下列关于Windows10 中文件操作的说法，正确的有（ ）。',JSON_ARRAY('A. 文件的复制可通过拖动文件来完成','B. 文件的删除与文件是否打开无关','C. 文件的移动可以通过剪贴板完成','D. 可同时更改多个文件的文件名'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）关于Windows10 任务管理器的说法，正确的有（ ）。',JSON_ARRAY('A. 可以查看正在运行的应用程序文件属性','B. 可以禁用启动项','C. 可以打开正在运行的应用程序文件所在位置','D. 可以卸载正在运行的应用程序'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）要使Word2016 正文文字显示更大些，下列方法有效的是（ ）。',JSON_ARRAY('A. 增大显示比例','B. 增大字号','C. 减小页边距','D. 减小行距'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题(本大题共 10 小题，每小题 2 分，共 20 分)每小题至少有两个','（多选）ChatGPT 的应用场景包括（ ）。',JSON_ARRAY('A. 人脸识别','B. 加密','C. 入侵检测','D. 数字签名'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）相比于传统机械硬盘，固态硬盘读写速度更快。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,32,32,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Windows10 中，单击对话框中的应用按钮后，修改的设置被应用对话框关闭。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,33,33,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Windows10 中，电脑睡眠唤醒后一定会导致剪贴板中的内容丢失。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,34,34,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Windows10 中，截图工具可以在截图时自动识别并去除图片中的水印。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,35,35,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Windows10 中，按删除键删除的文件立即被移至回收站。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,36,36,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）在Word2016 进行邮件合并时，数据源可以选择Excel 文件，不可以选择Word 文档。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,37,37,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）全文检索系统（例如中国知网）既能检索文献题录、内容摘要等信息，也能获取 文献全文。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,38,38,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）专利文献检索应用广泛，主要包括查询检索、专题检索、法律状态检索等。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,39,39,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）智慧城市建设能够利用人工智能等新一代信息技术，提升城市管理和服务水平。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,40,40,'choice','三、判断题(本大题共 10 小题，每小题 1 分，共 10 分)','（ ）小明在网上购买一本书后，网站给他推荐了许多类似书籍以及该书的其他购买者 购买过的物品，这体现了大数据时代相关而非因果的特点。 A.正确 B.错误',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,41,41,'fill','四、填空题(本大题共 5 小题，每小题 2 分，共 10 分)','将二进制转换为十进制数：(10001)2=_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,42,42,'fill','四、填空题(本大题共 5 小题，每小题 2 分，共 10 分)','开发、管理、使用、维护数据库系统时，主要分为数据库管理员、系统分析员、应用程 序员等。小红负责公司数据库运维工作，她的类别是_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,43,43,'fill','四、填空题(本大题共 5 小题，每小题 2 分，共 10 分)','在密码技术中，从密文“￥#@！”到明文“ok”转换的过程叫_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,44,44,'fill','四、填空题(本大题共 5 小题，每小题 2 分，共 10 分)','生成式人工智能包括自然语言生成、图片生成、音乐生成等功能。小伟创作了一个剧本， 想要使用生成式人工智能工具进行文字润化，该工具必须具有的一项功能是_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,45,45,'fill','四、填空题(本大题共 5 小题，每小题 2 分，共 10 分)','提供PaaS、SaaS 和IaaS 服务的新一代信息技术是_____。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,46,46,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','图1 中《世界文化遗产目录》的字体设置了（ ）。 A.删除线 B.下划线 C.着重号 D.双删除线',NULL,NULL,NULL,3,'reveal_only'),
(@pid,47,47,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','图1 所示的环绕方式为“嵌入型”，大勇认为不够美观，要更改成“紧密型环绕”，下 列操作不能实现的是（ ）。 A.右击图片→单击环绕文字→紧密型环绕 B.右击图片→单击设置图片格式→紧密型环绕 C.单击图片→单击“布局”→环绕文字→紧密型环绕 D.单击图片→单击“图片工具/格式”→环绕文字→紧密型环绕',NULL,NULL,NULL,3,'reveal_only'),
(@pid,48,48,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','正文中长城加粗显示效果没有达到大勇预期，为了取消该效果，大勇在查找和替换对话 框的“查找内容”和“替换为”文本框中输入了“长城”，然后应采取必要的操作步骤的 是（ ）。 ①单击“更多”→“格式”→“字体”选择字形为“常规”单击确定 ②光标定位到“替换为”文本框 ③单击“全部替换” ④光标定位到“查找内容”文本框 A.②①③ B.④①③ C.②③① D.④③① （二）Excel 操作题 小倩利用Excel2016 分析本市20 个景区容量流量数据，2023 年图2，2024 年图3。部 分数据截图如图所示。 图2 图3',NULL,NULL,NULL,3,'reveal_only'),
(@pid,49,49,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','为使标注记录具有唯一性，小倩在“2024”工作表中选择数据区域（A3:E7002），单击 “数据”选项卡后，下列可行的是（ ）。 A.单击“删除重复项”→选中所有列，单击“确定” B.单击“高级”→勾选“选择不重复的记录”，单击“确定” C.单击“合并计算”→添加引用位置→单击“确定” D.单击“排序”→选择“景区”为主要关键字→单击“确定”',NULL,NULL,NULL,3,'reveal_only'),
(@pid,50,50,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','在“2024”工作表中，要根据B 列数据填充E 列（例如B3 为“2014/3/15”，E3 填入“3 月”），首先在E3 单元格填写公式，再拖动其填充柄填充其他单元格，下列正确的是（ ）。 A.=YEAR(B3)+"月" B.=YEAR(B3)&"月" C.=MONTH(B3)&"月" D.=MONTH(B3)+"月"',NULL,NULL,NULL,3,'reveal_only'),
(@pid,51,51,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','在“2024”工作表中选择“景区”和“客流量”两列，插入折线图后，在对数据区域操 作过程中，发现折线图发生变化，最可能是（ ）。 A.套用了表格格式 B.执行了排序操作 C.插入了新列 D.设置了条件格式',NULL,NULL,NULL,3,'reveal_only'),
(@pid,52,52,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','要将2024 工作表中各个景区每日客流量（D 列）超过本景区2023 年日均流量（在2023 工作表中C 列）的数据行的字体格式设置为加粗倾斜，小倩在工作表应采取的操作步骤是 （ ）。 ①选择工作表数据区域（A3:E7002） ②选择景区和客流量两列数据（A3:A7002，D3:D7002） ③单击开始选项卡条件格式-突出显示单元格规则-其他规则，在新建格式规则对话框中选 择“使用公式确定要设置格式的单元格” ④在为符合此公式的值设置格式框中输入=$D3>VLOOKUP($A3,2023!$A$2:$C$22,3,0)-格 式-字体/字形-加粗斜体-确定-确定 ⑤在为符合此公式的值设置格式框中输入=D3>VLOOKUP($A3,2023!$A$2:$C$22,3,0)-格式 -字体/字形-加粗斜体-确定-确定 A.①③④ B.②③④ C.①③⑤ D.②③⑤ (三)PowerPoint2016 操作题 根据所学知识，回答以下问题。',NULL,NULL,NULL,3,'reveal_only'),
(@pid,53,53,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','要将第1 张幻灯片中SmartArt 对象（层次结构）中的“黄河锦带”所在矩形修改为圆角， 选中“黄河锦带”所在矩形，下列方法能够实现的是（ ）。 A.选择“开始”→“快速样式”→“圆角矩形” B.选择“插入”→“形状”→“圆角矩形” C.选择“SmartArt 工具/格式”→“更改形状”→“圆角矩形” D.选择“SmartArt 工具/格式”→“添加形状”→“圆角矩形”',NULL,NULL,NULL,3,'reveal_only'),
(@pid,54,54,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','要为第1 张幻灯片中的对象添加动画，使该幻灯片放映时，左上角的好客山东图片以“飞 入”首先出现，下列方法可行的是（ ）。 A.仅给好客山东图片添加动画选择“飞入” B.首先给其他对象添加动画(选择“飞出”)，然后给好客山东图片添加动画(选择“飞入”) C.首先给其他对象添加动画(选择“飞入”)，然后给好客山东图片添加动画(选择“飞入”) D.首先给所有对象逐一添加动画(选择“飞入”)，然后在“动画窗格”里将好客山东图片的 动画移到最前端',NULL,NULL,NULL,3,'reveal_only'),
(@pid,55,55,'essay','五、操作题(本大题共 10 小题，每小题 3 分，共 30 分)','要给第1 张幻灯片右边的泰山日出图片添加“链接”效果，在幻灯片放映时鼠标移动到 该图片上就自动跳转到第3 张幻灯片，应采取的操作步骤（请从下列操作中选出必要的） 是（ ）。 ①选中该图片，单击“插入”→“超链接” ②选中该图片，单击“插入”→“动作” ③在操作设置/鼠标悬停”对话框中单击“无动作”，选择第3 张幻灯片，单击“确定” ④在“操作设置/鼠标悬停”对话框中单击“超链接到”，选择第3 张幻灯片，单击“确定” A.①③ B.①④ C.②③ D.②④',NULL,NULL,NULL,3,'reveal_only'),
(@pid,56,56,'essay','六、分析题(本大题共5 小题，每小题2 分，共10 分)','小张在淄博与济南之间经常坐车，为了方便交通他在Word 中使用“插入”选项卡插入 了一个“形状”，如图所示。时间所在圆角矩形遮盖住了箭头。下列原因中，可能产生以 上问题的是（ ）。 A.两个箭头的环绕方式不合理 B.形状的组合有遗漏 C.形状叠放次数不合理 D.两个形状透明度过高',NULL,NULL,NULL,2,'reveal_only'),
(@pid,57,57,'essay','六、分析题(本大题共5 小题，每小题2 分，共10 分)','如果使用“绘图工具”选项卡解决，可采用的方式是（ ）。 A.两个箭头的透明度调成0 B.环绕方式设置为浮于文字上方 C.把箭头至于顶层 D.重新组合形状',NULL,NULL,NULL,2,'reveal_only'),
(@pid,58,58,'essay','六、分析题(本大题共5 小题，每小题2 分，共10 分)','计算A 组的平均销售额填入I5 单元格，在单元格中输入公式=AVERAGEIF(C3:C602,H5, D3:D602)，回车发现结果错误。以下原因中可能产生上述原因的是（ ）。 A.单元格区域引用错误 B.D 列数据存在文本数据项 C.D 列存在锁定单元格 D.公式中单元格引用错误',NULL,NULL,NULL,2,'reveal_only'),
(@pid,59,59,'essay','六、分析题(本大题共5 小题，每小题2 分，共10 分)','下列解决方案中，可行的是（ ）。 A.将公式改为“=AVERAGEIF(D3:D602,H5,C3:C602)” B.公式中D3:D602 单元格引用改为绝对引用 C.取消D3 列单元格区域的锁定 D.把D3:D602 单元格区域所有非数值型数据都改为数值型',NULL,NULL,NULL,2,'reveal_only'),
(@pid,60,60,'essay','六、分析题(本大题共5 小题，每小题2 分，共10 分)','为了向领导汇报公司销售团队的绩效评估结果，小李使用PowerPoint2016 制作演示文 稿，制作过程中，在幻灯片母版视图下给所有版式幻灯片都插入了Logo 图片，在关闭母版 视图后发现部分幻灯片没有显示Logo 图片，下列原因中可能产生上述问题的是（ ）。 A.幻灯片大小设置的不同 B.使用主题遮挡了Logo 图片 C.设置了隐藏幻灯片 D.Logo 图片设置了置于底层',NULL,NULL,NULL,2,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学I 2022 (21 题, published=1) · 中文卷解析·选择5·材料0·主观16·暂缺0·共21 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学I' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知函数 f(x) = x2 + a , x < 0 1 , x = 0 b − cos x , x > 0 在 x = 0 点连续，则 a 和 b 的值为（ ）',JSON_ARRAY('A. a = 1，b = 2','B. a = 1，b =− 2','C. a =− 1，b = 2','D. a =− 1，b =− 2'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','以下向量与a = (2, − 3,1)垂直的是（ ）.',JSON_ARRAY('A. ( − 2,3, − 1)','B. (3,0,1)','C. ( − 3,2,1)','D. (3,2,0)'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','以下微分方程通解是 y = C1e−2x + C2e4x，（C1，C2为任意常数）的是（ ）.',JSON_ARRAY('A. y'''' − 2y'' − 8y = 0','B. y'''' + 2y'' − 8y = 0','C. y'''' − 6y'' + 8y = 0','D. y'''' + 6y'' − 8y = 0'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','以下级数发㪚的是（ ）.',JSON_ARRAY('A. n=1 ∞ 1 n2+2','B. n=1 ∞ ln (1 + 1 n )','C. n=1 ∞ ( − 1)n 1 n','D. n=1 ∞ 1 3n'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','函数 f(x, y)在R2上连续，将 0 2 d x 0 3x f (x, y)dy + 2 4 d x 0 16−x2 f (x, y)dy 转化为极坐标（ ）.',JSON_ARRAY('A. 0 π 3 dθ 0 4 f (r cos θ , r sin θ )dr','B. 0 π 3 d θ 0 4 f (r cos θ , r sin θ )rdr','C. 0 π 6 d θ 0 4 f (r cos θ , r sin θ )dr','D. 0 π 6 d θ 0 4 f (r cos θ , r sin θ )rdr'),NULL,NULL,1,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','设极限lim x→∞ 1 + 1 3x kx = e2，则 k = _____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','设点(1, a)是曲线 y = ax3 − x2 − 2x + 3 的拐点，则 a = _____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知两点 A = ( − 2,1, − 1)，B = (2,5,1)，则|AB | = _____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','当|x| < 1 2时，函数 f(x) = 1 1−2x在 x = 0 处的幂级数展开式为_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知函数 f(x)在 R 上连续，且 0 1−2x f (t)dt = x2，则 f(x) =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,11,11,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','求极限lim x→2 x−2 2x−3−1.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,12,12,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','求极限lim x→0 1−cos 3 x 3x2 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,13,13,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','求不定积分 (2x ln x + sin x ) dx.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,14,14,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','求过点(0,2,3)且直线 x−1 2 = y+4 1 = z+1 3 和 x = 3 + t y = 2 + 2t z = 1 + t 都平行的平面方程.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,15,15,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','求微分方程 2 xy'' = y2 + 1 的通解.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','已知 z = z(x, y)是由方程sin ( xz) = yz 确定的函数，求 ∂z ∂x， ∂z ∂y.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 7 小题，每个小题 6 分，共 42 分）','计算二重积分 D xy3 dxdy，其中 D 是由直线 y = x，y = x 2，y = 1 围成的闭区间.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,18,18,'essay','四、应用题（本大题共 2 小题，第 18 小题 6 分，第 19 小题 8 分，共 14 分）','求函数 f(x) = 2 3 x3 − 5x2 + 12x − 1 3的极值，并判断是极大值还是极小值.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 2 小题，第 18 小题 6 分，第 19 小题 8 分，共 14 分）','过点( − 1,1)作曲线 y = 1 2 x2 + 1 2的法线，求其与该曲线围成的图形的面积.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,20,'essay','五、证明题（本大题共 2 小题，第 20 小题 6 分，第 21 小题 8 分，共 14 分）','证明：当 x > 0 时，x + x2 2 > (1 + x) ln ( 1 + x).（利用两次单调性）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,21,21,'essay','五、证明题（本大题共 2 小题，第 20 小题 6 分，第 21 小题 8 分，共 14 分）','设函数 f(x)在[1,3]上连续，在(1,3)内可导，且 f(1) = f(2) = 1，f(3) = 0， 证明：（1）存在ξ ∈ (2,3)使得 f(ξ) = 1 ξ成立； （2）存在η ∈ (1,3)，使得η2f''(η) + 1 = 0 成立.',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学I 2023 (21 题, published=1) · 中文卷解析·选择5·材料0·主观16·暂缺0·共21 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学I' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','函数 = ln (3 − 1)的定义域为（ ）.',JSON_ARRAY('A. 1 3 , + ∞','B. −∞, 1 3','C. 1 3 , + ∞','D. −∞, 1 3'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','下面属于三阶微分方程的是（ ）.',JSON_ARRAY('A. x2y'''' − xy'' + y = 0','B. x y'' 3 − 2yy'' + x = 0','C. y'''''' − 3y'''' = 0','D. x2dy + y3dx = 0'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','以下不是无穷小量的是（ ）.',JSON_ARRAY('A. tan x','B. sin 2x','C. ln (1 + x)','D. ex + 1'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知 f x 在 x = 3 可导，且limΔx→0 f 3−2Δx −f 3 Δx = 4，则f'' 3 =（ ）.',JSON_ARRAY('A. 2','B. −2','C. 4','D. −4'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','级数∑n=1 ∞ un收敛，则下列收敛的是（ ）.',JSON_ARRAY('A. n=1 ∞ ( − 1)nun∑','B. n=1 ∞ un2 + 1 n2∑','C. n=1 ∞ un∑','D. n=1 ∞ un + 1 n2∑'),NULL,NULL,1,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','极限limx→0 (1 + x) 5 x =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知a = ( − 2,1, k), b = (4,5,1)，且a ⊥ b ，则 k = ______.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知参数方程 x = t3 + 2t y = arcsint，则 dy dx t=0 =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知∫0 2x f(t)dt = x3 + x2，则 f(4) =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','二重积分∫−1 0 dx∫−x −x2+2x+4 f(x, y)dy + ∫0 1 dx∫5x −x2+2x+4 f(x, y)dy 交换积分次序后为_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,11,11,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求极限limx→+∞ x2 + 3x − x .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,12,12,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求极限limx→0 e1−cos x−cosx x2 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,13,13,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求不定积分∫ 1 x2+10x+26 dx.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,14,14,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求过点 A 1,0, − 4 ，B(3,1, − 2)且与直线 x−1 3 = y+2 −1 = z 2平行的平面方程.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,15,15,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求二元函数 z = y2 + 1 + ln (x − y)的全微分.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求微分方程x2y'' + xy = x2 + lnx 满足初始条件y x=1 = 1 2的特解.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','计算二重积分∬D xy x2+y2 dxdy,其中 D = x, y∣0 ≤ y ≤ 3x，1 ≤ x2 + y2 ≤ 4 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,18,18,'calc','三、计算题（本大题共 8 小题，每个小题 6 分，共 48 分）','求幂级数∑n=0 ∞ xn+2 (n+2)n!的收敛域与和函数.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 2 小题，每个小题 7 分，共 14 分）','求由直线 x + y = 2，曲线 y = x与 y 轴围成图形绕 x 轴旋转一周而围成旋转体的体积.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,20,'essay','四、应用题（本大题共 2 小题，每个小题 7 分，共 14 分）','求函数 f(x) = (2x − 3)ex − x2 + x 的极值.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,21,21,'essay','五、证明题（本大题共 1 小题，每个小题 8 分，共 8 分）','设函数 f x 在 0,1 连续，且 0 1 f x dx∫ = 1 证明：（1）存在ξ ∈ (2,3)使得 f(ξ) = 1 ξ成立； （2）存在η ∈ (1,3)，使得η2f''(η) + 1 = 0 成立.',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学I 2024 (21 题, published=1) · 中文卷解析·选择5·材料0·主观16·暂缺0·共21 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学I' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','下列函数是偶函数的是（ ）.',JSON_ARRAY('A. = tan','B. = cos','C. = 3','D. = 3'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','设函数为 = 4 + 5, < 1 2 − 2, ≥ 1，则 = 1 是函数的（ ）.',JSON_ARRAY('A. 连续点','B. 可去间断点','C. 跳跃间断点','D. 无穷间断点'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','函数 = 2(2 ln − 5)的拐点是（ ）.',JSON_ARRAY('A. (2, 4)','B. (2, − 4)','C. (, 32)','D. (, − 32)'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','函数 = arctan 2 在点 1,1 处的全微分为（ ）.',JSON_ARRAY('A. + 1 2','B. 1 2 + 1 2','C. 1 2 +','D. 2 +'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','下列级数绝对收敛的是（ ）.',JSON_ARRAY('A. =1 ∞ −1 2+3','B. =1 ∞ −1 2+1','C. =1 ∞ −1 2+1','D. =1 ∞ −1 1+ln3'),NULL,NULL,3,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','极限lim →0 1 + sin 2 1 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知两个向量 = 3,0,4 ， = 2,2,1 ，则这两个向量的夹角余弦为 .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','微分方程 16'''' − 8'' + = 0 的通解为 .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','级数 =0 ∞ −1 −1 2+1 3 的收敛半径为 .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数 在上有连续的导数，且 0 = (1)，且 0 1 ( − ) = 2 + 1，则 0 1 ''() = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,11,11,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求极限lim →3 −3 − 9 2−3 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,12,12,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求极限lim →1 −1+−2 1−−ln .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,13,13,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','已知函数 = 是由方程− + 2 − = 1 所确定的隐函数，求该函数在点 1,1 处的切线方程.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,14,14,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求不定积分 2+5+2 2+4 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,15,15,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求定积分 0 1 1−2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','已知平面过点 1,0,2 且垂直于直线 − + + 2 = 0 − 3 + 2 + 1 = 0，求原点到平面的距离.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求微分方程 − 1 + 2 ln = 0 的通解.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,18,18,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','计算二重积分 = 2 + 2 −5 2 ，其中是由 = 1 − 2与直线 = ， = 1 所围成的闭区域.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 2 小题，每小题 7 分，共 14 分）','计算由曲线 = 3, ≤ 0 2 − 2, > 0，与 =− 2 + 4 所围成图形的面积.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,20,20,'essay','四、应用题（本大题共 2 小题，每小题 7 分，共 14 分）','求函数 , = 2 − 4 + 22 + 23的极值，并判断是极大值还是极小值.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,21,21,'essay','五、证明题（本大题共 1 小题，每小题 8 分，共 8 分）','已知函数 在 0,1 上连续，在 0,1 内可导，且 0 = 1 = 0，设 在 0,1 上的最大值为 M > 0 ， 证明：在 0,1 内存在两个不同的点，，使得 '' + '' ≥ 4.',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学I 2025 (21 题, published=1) · 中文卷解析·选择5·材料0·主观16·暂缺0·共21 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学I' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','下列函数是周期函数的是（ ）.',JSON_ARRAY('A. 𝑥2','B. 𝑒 𝑥','C. 𝑐𝑜𝑠⁡ 𝑥','D. 𝑙𝑛⁡(1 + 𝑥2)'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数𝑦 = 𝑥+3 2𝑥−4，则函数的水平渐近线为（ ）.',JSON_ARRAY('A. 𝑦 = 1 2','B. 𝑦 = − 1 2','C. 𝑦 = 2','D. 𝑦 = −3'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','曲线方程{𝑥 = 𝑡 + sin⁡ 𝑡 𝑦 = 𝑡3 + 𝑒𝑡 ，则曲线在𝑡 = 0处的切线斜率为（ ）.',JSON_ARRAY('A. − 1 2','B. 1 2','C. −2','D. 2'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','微分方程𝑦′′ − 6𝑦′ + 34𝑦 = 0的通解为（ ）.',JSON_ARRAY('A. 𝑦 = 𝑒5𝑥(𝐶1sin⁡ 3𝑥 + 𝐶2cos⁡ 5𝑥)','B. 𝑦 = 𝑒3𝑥(𝐶1sin⁡ 5𝑥 + 𝐶2cos⁡ 5𝑥)','C. 𝑦 = 𝑒5𝑥(𝐶1sin⁡ 3𝑥 + 𝐶2cos⁡ 3𝑥)','D. 𝑦 = 𝑒3𝑥(𝐶1sin⁡ 5𝑥 + 𝐶2cos⁡ 3𝑥)'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑧 = 𝑎𝑟𝑐𝑠𝑖𝑛⁡(𝑥 + 2𝑦)，则 𝜕2𝑧 𝜕𝑥𝜕𝑦 =（ ）.',JSON_ARRAY('A. 2(𝑥+2𝑦) [1−(𝑥−2𝑦)2] 3 2','B. −2(𝑥−2𝑦) [1−(𝑥−2𝑦)2] 3 2','C. −(𝑥−2𝑦) [1−(𝑥−2𝑦)2] 3 2','D. 𝑥+2𝑦 [1−(𝑥−2𝑦)2] 3 2'),NULL,NULL,3,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑓(𝑥) = {𝑥2 + 3, 𝑥 ≤ 1 2𝑥−1, 𝑥 > 1，则𝑓[𝑓(0)] = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知向量𝑎⃗ = (3, 𝑘, −1)，向量𝑏⃗⃗ = (2,1,3𝑘)且两向量垂直，则𝑘 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑓(𝑥)在𝑅上连续且∫1 2 𝑓(2𝑥)d𝑥 = 1，则∫2 4 𝑓(𝑥)d𝑥 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑧 = 𝑥2𝑒𝑦，则全微分𝑑𝑧 = . 2',NULL,NULL,NULL,3,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑓(𝑥)在𝑅上有连续的导数，积分𝐼 = ∫ 1 0 d𝑦 ∫ √𝑦 0 𝑓(𝑥, 𝑦)d𝑥 + ∫ 2 1 d𝑦 ∫ 1−√𝑦−1 0 𝑓(𝑥, 𝑦)d𝑥，则交换积分 次序后得𝐼 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,11,11,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求极限lim 𝑥→3 𝑥−3 √𝑥2+𝑥−3−𝑥.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,12,12,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求极限lim 𝑥→0 sin⁡ 𝑥+3ln⁡(1+𝑥) 1+𝑥−cos⁡ 2𝑥 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,13,13,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求不定积分∫ ( 1 𝑥2 + 𝑥cos⁡ 𝑥) d𝑥.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,14,14,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求定积分∫ 4 0 ln⁡(2 + √𝑥)d𝑥.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,15,15,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求过点(2, −1,1)且平行于直线{3𝑥 − 𝑦 + 2𝑧 + 1 = 0 𝑥 − 2𝑦 + 3𝑧 + 5 = 0的直线方程. 3',NULL,NULL,NULL,6,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','求微分方程𝑒𝑦𝑦′ = 𝑥2(5 + 𝑒𝑦)的通解.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','计算幂级数∑ ∞ 𝑛=0 (𝑥−5)𝑛 (√𝑛+1)3𝑛的收敛域.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,18,18,'calc','三、计算题（本大题共 8 小题，每小题 6 分，共 48 分）','计算二重积分∬ 𝐷 𝑥d𝑥d𝑦，其中𝐷是由曲线𝑦 = |𝑥2 − 4|和直线𝑦 = 3𝑥所围成的闭区域.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,19,19,'essay','四、证明题（本大题共 1 题，每小题 7 分，共 14 分）','设平面图形𝐷是由曲线𝑦 = 𝑒 𝑥, 𝑦 = √2𝑥 − 𝑥2和直线𝑥 = 0, 𝑥 = 1所围成的封闭区域，求𝐷绕𝑥轴旋转一周 得到的旋转体体积．',NULL,NULL,NULL,7,'reveal_only'),
(@pid,20,20,'essay','四、证明题（本大题共 1 题，每小题 7 分，共 14 分）','求函数𝑓(𝑥) = 𝑥 − 𝑙𝑛⁡(1 + 𝑥2) − 4𝑎𝑟𝑐𝑡𝑎𝑛⁡ 𝑥的极值，并判断是极大值还是极小值. 4',NULL,NULL,NULL,7,'reveal_only'),
(@pid,21,21,'essay','五、证明题（本大题共 1 题，每小题 8 分，共 8 分）','已知函数𝑓(𝑥)在[0,1]处连续， 在(0,1)处可导， 证明：∃𝜉 ∈ (0,1)， 使得∫ 1 0 𝑓(𝑥)d𝑥 = 𝑓(0) + 𝑓′(𝜉)(1 − 𝜉)．',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学II 2022 (20 题, published=1) · 中文卷解析·选择5·材料0·主观15·暂缺0·共20 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学II' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','当 → 0 时，以下函数不是的等价无穷小量的是（ ）.',JSON_ARRAY('A. ln 1 +','B. cos','C. tan','D. arctan'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','极限lim →0 −1 sin 3 =（ ）.',JSON_ARRAY('A. − 1 3','B. 0','C. 1 3','D. ∞'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','函数 = 23 + 32 + 1 的极小值点是（ ）.',JSON_ARRAY('A. =− 1','B. = 0','C. = 1','D. = 2'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知函数 = ln + ，则与其他三项不相等的选项是（ ）.',JSON_ARRAY('A. ⋅','B. 2','C. 2 2','D. 2 2'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','以下定积分最小的是（ ）.',JSON_ARRAY('A. 0 1 sin2','B. 0 1','C. 0 1','D. 0 1 2'),NULL,NULL,1,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知 = − 2 , < 0 0, ≥ 0 ，则 3 =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知 = sin2 2 , < 0 0, ≥ 0 在 = 0 处连续，则 =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知 = 2 + cos + 1 ，则微分 =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知某产品成本函数为 = 5 + 8 ，则产量 = 4 时的边际成本为_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已 知 函 数 , 在 2 连 续 ， 设 = 0 1 0 2 , + 1 2 0 −2 2 , ， 交 换 积 分 次 序 后 =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,11,11,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求极限lim →1 −1 +3−2.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,12,12,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求极限 lim →∞ +2 −3 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,13,13,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求曲线 = 2 + 在 0,1 处的切线方程.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,14,14,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求不定积分 cos + 2 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,15,15,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求定积分 0 3 +1 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,16,16,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求微分方程 '' 1−2 = 1 2 的通解.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,17,17,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','设 = , 是由sin = 2 + 确定的函数，求 ， .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,18,18,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','计算二重积分 2 − 2 ，其中 D 是由直线 = 2， = 1， = 2 围成的闭区间.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 1 小题，每个小题 7 分，共 7 分）','求曲线 = 和直线 + 3 = 4， = 4 所围成的图形的面积.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,20,'essay','五、证明题（本大题共 1 小题，每个小题 1 分，共 7 分）','证明：当 0 < < 2时，sin 2 + 4 tan > 6.',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学II 2023 (20 题, published=1) · 中文卷解析·选择4·材料0·主观15·暂缺0·共20 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学II' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','以下函数是奇函数的是（ ）.',JSON_ARRAY('A. B.2 + 1','C. cos','D. sin'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知函数() = +4 2+4，则 =− 4 是函数的（ ）.',JSON_ARRAY('A. 连续点','B. 可去间断点','C. 跳跃间断点','D. 无穷间断点'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','微分方桯'''''' − '' 2 + 4 = 0 的阶数是（ ）.',JSON_ARRAY('A. 1','B. 2','C. 3','D. 4'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知函数 = ，则 ∂2 ∂∂ =（ ）.',JSON_ARRAY('A. 1−22 1+22 2','B. 1 1+22','C. 22−1 1+22 2','D. − 1 1+22 2'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 5 小题，每个小题 3 分，共 15 分）','() = ∫0 2+2 ，则''() =（ ）.',JSON_ARRAY('A. 2() + 22','B. () + 22','C. 222','D. 22'),NULL,NULL,1,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知 = 4 − 2的定义域是_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','曲线 = ln 2 + 2 在(1, ln 3)处的切线斜率是______.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','己知∫ () = 3，∫ [2() − 3()] = 5，则∫ () =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','函数() = 34 − 43的极小值为_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每个小题 3 分，共 15 分）','已知() = 3 + ∫0 4 2 ，则∫0 1 () =_____.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,11,11,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求极限lim→0 1 − 3 2+3 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,12,12,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求极限lim→0 cos− 2 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,13,13,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','已知函数() = + ln(1 + ), ≥ 0 , < 0 在 = 0 可导，求，.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,14,14,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求不定积分∫ 23−+3 2 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,15,15,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求定积分∫0 2 sin sin2.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,16,16,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','求微分方程 4'''' − 12'' + 9 = 0 满足 =0 = 1，'' =0 = 2 的特解.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,17,17,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','设 = sin 2 + + 2，求全微分.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,18,18,'essay','三、解答题（本大题共 8 小题，每个小题 7 分，共 56 分）','计算二重积分 ，其中是由曲线 = 2， = 82， = 1 围成的闭区间．',NULL,NULL,NULL,5,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 1 小题，每个小题 7 分，共 7 分）','求由直线 = 3 3 ，曲线 = 4 − 2与 y 轴所围成的图形绕轴旋转一周而成的旋转体的体积.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,20,'essay','五、证明题（本大题共 1 小题，每个小题 7 分，共 7 分）','设函数()在 0,1 连续，在 0,1 可导，且 0 > 0， 1 < 1， 证明：（1）存在0 ∈ (0,1)，使得(0) = 0； （2）存在 ∈ (0,1)，使得 3 − ''() = 2().',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学II 2024 (20 题, published=1) · 中文卷解析·选择5·材料0·主观15·暂缺0·共20 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学II' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','函数 = sin 3 − 的定义域是（ ）.',JSON_ARRAY('A. (3, + ∞)','B. [3, + ∞)','C. ( − ∞, 3)','D. ( − ∞, 3]'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','当 → 0 时，以下函数是无穷小量的是（ ）.',JSON_ARRAY('A. = cos','B. =','C. = ln (1 + )','D. = arcsin (1 + )'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','曲线 = +1 −3的垂直渐近线是（ ）.',JSON_ARRAY('A. = 1','B. =− 1','C. = 3','D. =− 3'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数 的导数是2，则 的一个原函数为（ ）.',JSON_ARRAY('A. 1 4 2 +','B. 1 4 2 + 2','C. 42 +','D. 42 + 2'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数 在上连续， = 0 2 (2 − ) ，则'' =（ ）.',JSON_ARRAY('A. −2 2','B. 2 2','C. −2','D. 2'),NULL,NULL,3,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','极限lim →0 1 + 2 4 sin = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数 = arctan + − 2 3，则'''' 1 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 [ + 3 ] = 8， [2 − ] = 2，求 [ + ] .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数 = ln 2 + 3 ，则 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知二重积分 = 1 2 0 1− 2−2 (, ) + 2 3 0 4−2−3 (, ) ，则交换积分次序后 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,11,11,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求极限lim →0 4+3− 4−3 .',NULL,NULL,NULL,7,'reveal_only'),
(@pid,12,12,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求极限lim →1 −1− 1−+ln .',NULL,NULL,NULL,7,'reveal_only'),
(@pid,13,13,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求曲线 = 2 + 2 − 2在点 1,1 处的切线方程.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,14,14,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求不定积分 (3 + cos ) .',NULL,NULL,NULL,7,'reveal_only'),
(@pid,15,15,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求定积分 −1 1 −−2 1+2 .',NULL,NULL,NULL,7,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求微分方程 1 + 3 '' + 32 − ln = 0 的通解.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','计算二重积分 ，其中是由曲线 = 1 − 2与直线 = ， = 2 − 2 所围成的闭区域.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,18,18,'essay','四、应用题（本大题共 2 小题，每小题 7 分，共 14 分）','求由曲线 = 2 ，直线 = + 1， =− 所围成的封闭区域的面积.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 2 小题，每小题 7 分，共 14 分）','求函数 , = 23 + 12 − 32 − 30的极值，并判断是极大值还是极小值.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,20,20,'essay','五、证明题（本大题共 1 小题，每小题 7 分，共 7 分）','已知函数 在 , 上连续，在 , 内可导，当 ∈ , 时，都有 '' ≤ ，且 () = 0，证明： '' + '' ≤ ( − ).',NULL,NULL,NULL,7,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学II 2025 (20 题, published=1) · 中文卷解析·选择5·材料0·主观15·暂缺0·共20 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学II' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','𝑥 → +∞时，下列函数为无穷大量的是（ ）.',JSON_ARRAY('A. 𝑒 𝑥','B. 1 𝑥','C. sin⁡ 𝑥','D. 𝑎𝑟𝑐𝑡𝑎𝑛⁡ 𝑥'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','设𝑓(𝑥) = {ln⁡(𝑥 + 1), 𝑥 ≥ 0 1 − 𝑥2, 𝑥 < 0 ，则𝑥 = 0为函数的（ ）间断点.',JSON_ARRAY('A. 连续','B. 可去','C. 跳跃','D. 第二类'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','微分方程(𝑦′′)2 − 2𝑦′′ + 3𝑦′ + 4𝑦3 = 0的阶数为（ ）.',JSON_ARRAY('A. 1 阶','B. 2 阶','C. 3 阶','D. 4 阶'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑓′(5) = 2且 lim Δ𝑥→0 𝑓(5+𝑘Δ𝑥)−𝑓(5+Δ𝑥) Δ𝑥 = 3，则𝑘 =（ ）.',JSON_ARRAY('A. 2','B. 3','C. 5 2','D. − 2 3'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、选择题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝐼1 = ∫ 𝜋 4 0 𝑒sin⁡ 𝑥d𝑥, 𝐼2 = ∫ 𝜋 4 0 𝑒cos⁡ 𝑥d𝑥, 𝐼3 = ∫ 𝜋 4 0 𝑒1−cos⁡ 𝑥d𝑥，下列不等式中成立的是（ ）.',JSON_ARRAY('A. 𝐼1 ≤ 𝐼2 ≤ 𝐼3','B. 𝐼2 ≤ 𝐼3 ≤ 𝐼1','C. 𝐼3 ≤ 𝐼2 ≤ 𝐼1','D. 𝐼3 ≤ 𝐼1 ≤ 𝐼2'),NULL,NULL,3,'answerable'),
(@pid,6,6,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑓(𝑥) = 𝑒 𝑥−1，则𝑓[𝑓(1)] = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,7,7,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知曲线方程{𝑥 = 𝑡 + cos⁡ 𝑡 𝑦 = 𝑡3 + 2𝑡 ，则曲线在𝑡 = 0处的切线斜率为 .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,8,8,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知(0, −3)是函数𝑦 = (𝑥 − 3)𝑒 𝑥 + 𝑥3 + 𝑎𝑥2的拐点，则𝑎 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,9,9,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数∫ 3 0 𝑓(𝑥)d𝑥 = 1，则∫ 1 0 𝑓(3𝑥)d𝑥 = . 2',NULL,NULL,NULL,3,'reveal_only'),
(@pid,10,10,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知𝑓(𝑥)在𝑅上有连续的导数，积分𝐼 = ∫ 2 0 d𝑦 ∫ √𝑦 0 𝑓(𝑥, 𝑦)d𝑥 + ∫ 4 2 d𝑦 ∫ √𝑦 √2𝑦−4 𝑓(𝑥, 𝑦)d𝑥，则交换积分次 序后得𝐼 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,11,11,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求极限 lim 𝑥→∞ ( 𝑥+4 𝑥+2) 3𝑥−1 .',NULL,NULL,NULL,7,'reveal_only'),
(@pid,12,12,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求极限𝑙𝑖𝑚 𝑥→0 ∫ 𝑥 0 𝑠𝑖𝑛⁡ 𝑡2𝑑𝑡 𝑥−𝑎𝑟𝑐𝑡𝑎𝑛⁡ 𝑥.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,13,13,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求不定积分∫ (3+2ln⁡ 𝑥)2 𝑥 d𝑥.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,14,14,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求定积分∫ 1 0 𝑥𝑎𝑟𝑐𝑡𝑎𝑛⁡ √𝑥𝑑𝑥.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,15,15,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','求微分方程(3 + 𝑥2)𝑦′ = 2𝑥𝑒−𝑦的通解. 3',NULL,NULL,NULL,7,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','已知二元函数𝑧 = 𝑓(𝑥, 𝑦)由方程𝑒2𝑥+𝑧 = 𝑥2 − 𝑦2𝑧所确定，求 𝜕𝑧 𝜕𝑥 , 𝜕𝑧 𝜕𝑦.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 7 小题，每小题 7 分，共 49 分）','计算二重积分∬ 𝐷 √𝑥2 + 𝑦2𝑑𝑥𝑑𝑦，其中𝐷是由曲线𝑦 = √2𝑥 − 𝑥2和直线𝑦 = √3 3 𝑥所围成的闭区域.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,18,18,'essay','四、应用题（本大题共 2 题，每小题 7 分，共 14 分）','设平面图形𝐷是由曲线𝑦 = 𝑥2 + 1, 𝑦 = √𝑥和直线𝑥 = 0, 𝑥 = 2所围成的封闭区域，求𝐷绕𝑥轴旋转一周得 到的旋转体体积.',NULL,NULL,NULL,7,'reveal_only'),
(@pid,19,19,'essay','四、应用题（本大题共 2 题，每小题 7 分，共 14 分）','求函数𝑓(𝑥) = (𝑥2 − 4𝑥 − 12)ln⁡(2 + 𝑥) − 1 2 𝑥2 + 6𝑥的极值，并判断是极大值还是极小值. 4',NULL,NULL,NULL,7,'reveal_only'),
(@pid,20,20,'essay','五、证明题（本大题共 1 题，每小题 7 分，共 7 分）','已知函数 𝑓(𝑥)在[0,2]处连续，在 (0,2)处可导且 ∫ 1 0 𝑓(𝑥)d𝑥 = ∫ 2 1 𝑓(𝑥)d𝑥 − 1，证明： ∃𝜉 ∈ (0,2)，使得 𝑓′(𝜉) = 1.',NULL,NULL,NULL,7,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学III 2022 (24 题, published=1) · 中文卷解析·选择9·材料0·主观14·暂缺0·共24 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学III' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','求cos 4 − 2的定义域（ ）.',JSON_ARRAY('A. −∞, −2','B. 2, + ∞','C. 0,2','D. −2,2'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','以下函数是偶函数的是（ ）.',JSON_ARRAY('A. 1','B. −','C. ln','D. tan'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','当 → 0 时，以下哪个不是无穷小（ ）.',JSON_ARRAY('A. − sin','B. − tan','C. − cos','D. 1 − cos'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知函数 = 2−3 2−9 ，则 = 3 是函数 的（ ）间断点',JSON_ARRAY('A. 可去间断点','B. 跳跃间断点','C. 无穷间断点','D. 连续点'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数在 0,1 是单调减函数的是（ ）.',JSON_ARRAY('A. ln','B. C. − ln','D. −'),NULL,NULL,3,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','若函数 = 可导， = 3，则 =（ ）.',JSON_ARRAY('A. '' 32','B. '' 3','C. 32'' 32','D. 32'' 3'),NULL,NULL,3,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知'' = − 1 − 1 ，则（ ）.',JSON_ARRAY('A. = 0 为极小值点， = 1 为极大值点','B. = 0 为极大值点， = 1 为极小值点','C. = 0 为极值点， = 1 不是极值点','D. = 0 不是极值点， = 1 为极值点'),NULL,NULL,3,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知−2是函数 的一个原函数，则'' =（ ）.',JSON_ARRAY('A. 4−2','B. −2−2','C. −2','D. 1 2 −2'),NULL,NULL,3,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','下列选项中结果大于 1 的是（ ）.',JSON_ARRAY('A. 1 2 1','B. 1 2','C. 1 2 sin2','D. 1 2 cos2'),NULL,NULL,3,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知函数 = sin + ，则 =（ ）.',JSON_ARRAY('A. sin +','B. 2 sin +','C. sin +','D. 2 sin +'),NULL,NULL,3,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 = 3 ， ≤ 2 0 ， > 2 ，则 5 =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知lim →1 =− 1，lim →1 =− 2，则lim →1 2 ⋅ =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','极限 lim →+∞ +ln 2+1 =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 = cos 3，则 =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 0 1 = 1 + 4 0 2 = 0 2 + 1，则 1 2 =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,16,16,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','计算极限 lim →∞ 1 + 1 4 2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,17,17,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','计算极限lim →0 2 −1 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,18,18,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','已知函数 = 2 + 1 +1，求".',NULL,NULL,NULL,6,'reveal_only'),
(@pid,19,19,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','已知 = + ， < 0 0 ， = 0 + ， > 0 在 = 0 处连续，求，的值.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,20,20,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','求曲线 22 + 2 = 3 在点 1，1 处的切线方程.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,21,21,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','求不定积分 2 ln + 1 2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,22,22,'essay','三、解答题（本大题共 7 小题，每小题 6 分，共 42 分）','求定积分 −1 3 + 1 − .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,23,23,'essay','四、应用题（本大题共 2 小题，第 22 小题 6 分，第 23 小题 7 分，共 13 分）','在 R 上连续， 0 2 = ，求 .',NULL,NULL,NULL,5,'reveal_only'),
(@pid,24,24,'essay','四、应用题（本大题共 2 小题，第 22 小题 6 分，第 23 小题 7 分，共 13 分）','已知 0 < < 2，曲线 = 2 ， = 和直线 = 2 所围区域的面积为 S，求： （1）面积为 S 的值； （2）当取何值时，面积最小，并求出最小的面积值.',NULL,NULL,NULL,5,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学III 2023 (24 题, published=1) · 中文卷解析·选择9·材料0·主观14·暂缺0·共24 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学III' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数 = −2的定义域为（ ）.',JSON_ARRAY('A. [2, + ∞)','B. ( − ∞, − 2]','C. ( − 2,2)','D. [ − 2,2]'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','下列函数在其定义域内有界的是（ ）.',JSON_ARRAY('A. B.ln','C. 2','D. cos'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','当 → 0 时，以下不是与为等价无穷小量的是（ ）.',JSON_ARRAY('A. sin','B. tan','C. 1 − cos','D. ln(1 + )'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知函数() = ln , > 1 2, ≤ 1 ，则 = 1 是函数()的（ ）间断点.',JSON_ARRAY('A. 可去间断点','B. 跳跃间断点','C. 无穷间断点','D. 连续点'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数 = 22 + 3，则 =（ ）.',JSON_ARRAY('A. 4 22+3','B. 2 22+3','C. 22+3','D. 2 22+3'),NULL,NULL,3,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数 = ln (2 + 5)则'''' =（ ）.',JSON_ARRAY('A. − 4 (2+5)2','B. 4 (2+5)2','C. − 2 (2+5)2','D. 2 (2+5)2'),NULL,NULL,3,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知sin 是 的原函数，则 2 的原函数是（ ）.',JSON_ARRAY('A. 2sin2','B. sin2','C. 2sin2 + 1','D. 1 2 sin2 + 1'),NULL,NULL,3,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数 = ( − 1)的拐点是（ ）.',JSON_ARRAY('A. −2, − 3 2','B. −1, − 2','C. (0, − 1)','D. (1,0)'),NULL,NULL,3,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知()在[1,4]可导，(4) = 1，∫0 4 ''() = 3，则∫0 4 () =（ ）.',JSON_ARRAY('A. -1','B. 0','C. 1','D. 3'),NULL,NULL,3,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知() = ∫0 2 sin2，则''() =（ ）.',JSON_ARRAY('A. sin 42','B. 2 sin 42','C. sin42 + ∫0 2 sin2','D. 2sin42 + ∫0 2 sin2'),NULL,NULL,3,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 = ，() = 2，则[( − 1)] =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','极限lim→∞ 1 − 4 3 = ______.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知∫ () =− 2，∫ () = 3，则∫ [3() + 4()] =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知隐函数 + ln ( + − 1) = 1，则 (1,1) =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知() = 32 − 2 + ∫0 3 ()，则∫0 2 () =_____.',NULL,NULL,NULL,3,'reveal_only'),
(@pid,16,16,'essay','三、解答题（本大题共 6 小题，每小题 6 分，共 36 分）','求极限lim→+∞ 42 + − 2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,17,17,'essay','三、解答题（本大题共 6 小题，每小题 6 分，共 36 分）','求极限lim→0 −ln (1+) 1−cos .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,18,18,'essay','三、解答题（本大题共 6 小题，每小题 6 分，共 36 分）','已知() = −1, > 1 , = 1 2 + − , < 1 在 = 1 处连续，求 a，b.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,19,19,'essay','三、解答题（本大题共 6 小题，每小题 6 分，共 36 分）','求曲线 = 2 + 1 在(0,1)处的法线方程.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,20,20,'essay','三、解答题（本大题共 6 小题，每小题 6 分，共 36 分）','求不定积分∫ + 2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,21,21,'essay','三、解答题（本大题共 6 小题，每小题 6 分，共 36 分）','求定积分∫0 1 3 − 1 − 2.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,22,22,'essay','四、应用题（本大题共 2 小题，第 22 小题 6 分，第 23 小题 7 分，共 13 分）','求由 = 2, > 0 −, ≤ 0与 =− 2 + 2 + 4 围成的图形面积.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,23,23,'essay','四、应用题（本大题共 2 小题，第 22 小题 6 分，第 23 小题 7 分，共 13 分）','已知实数 ≠ 0，求函数 = 23 − 62 + 9的极值，并判断是极大值还是极小值.',NULL,NULL,NULL,5,'reveal_only'),
(@pid,24,24,'essay','五、证明题（本大题共 1 小题，每小题 6 分，共 6 分）','设函数()在[1,4]内具有二阶导数，且 3(2) = 2(1) + (4)，证明在(1,4)内存在一点，使得''''() = 0.',NULL,NULL,NULL,6,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学III 2024 (24 题, published=1) · 中文卷解析·选择9·材料0·主观14·暂缺0·共24 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学III' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','下列函数是奇函数的是（ ）.',JSON_ARRAY('A. ln','B. 3','C. cos','D. 2'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','下列函数是周期函数的是（ ）.',JSON_ARRAY('A. 2B.','C. sin D .'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','当 → 0 时，以下函数是2的等价无穷小的是（ ）.',JSON_ARRAY('A. sin2','B. sin 2','C. cos2','D. 2−1'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','点 = 1 是函数 = 2−2 2−3+2的（ ）.',JSON_ARRAY('A. 可去间断点','B. 跳跃间断点','C. 震荡间断点','D. 无穷间断点'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知函数 = 2(5)，则 =（ ）.',JSON_ARRAY('A. 10 5 '' 5','B. 10'' 5','C. 2 5 '' 5','D. 2'' 5'),NULL,NULL,3,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','曲线 = 35 − 54 + 4 + 2 的拐点是（ ）.',JSON_ARRAY('A. 1,2','B. 1,4','C. 0,2','D. 0,4'),NULL,NULL,3,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知1 = −1 1 cos 1+2 ，2 = −1 1 sin 1+2 ，3 = −1 1 1 1+2 ，则下列不等式成立的是（ ）.',JSON_ARRAY('A. 1 ≤ 2 ≤ 3','B. 2 ≤ 3 ≤ 1','C. 3 ≤ 2 ≤ 1','D. 2 ≤ 1 ≤ 3'),NULL,NULL,3,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','1 2 1 1 =（ ）.',JSON_ARRAY('A. 1 1 2','B. 1 1 2','C. 1 2 1','D. 1 2 1'),NULL,NULL,3,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知 = −3 + ，则 的一个原函数为（ ）.',JSON_ARRAY('A. −3( − 1 3 )','B. −3( + 1 3 )','C. −3( − 1)','D. −3( + 1)'),NULL,NULL,3,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知 = 3 + 2 cos ，则'' =（ ）.',JSON_ARRAY('A. 3 + 2 cos ln 3 + 2 cos − 3+2 cos','B. −2 3 + 2 cos −1','C. 3 + 2 cos ln 3 + 2 cos − 2 3+2 cos','D. 3 + 2 cos ln (3 + 2 cos )'),NULL,NULL,3,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 lim →∞ = 2， lim →∞ =− 3，则 lim →∞ + 1 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知lim →0 1 + 3 = ，则实数 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','曲线 = 2−1 + 2在点 1 2 , 5 4 处的法线斜率是 .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 1 2 + 2 2 3 = 2，2 1 2 − 2 3 = 1，则 1 3 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知函数 在上有连续的导数， 2 = 3，且 0 2 + = 2 + 1，则 0 2 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求极限lim →1 1 2− − 2 2−1 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求极限lim →0 rctan − sin − .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,18,18,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','已知函数 = 2 cos + , < 0 2, = 0 + 1 − , > 0 在 = 0 处连续，求, 的值.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,19,19,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求曲线 − sin − = 0 在点 0,1 处的切线方程.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,20,20,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求不定积分 (2 tan2 − + 5) .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,21,21,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求定积分 0 1 2ln (2 + 1) .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,22,22,'essay','四、应用题（本大题共 2 小题，每小题 6 分，共 12 分）','求曲线 = 1 与直线 =− + 2， = 4所围成的图形的面积.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,23,23,'essay','四、应用题（本大题共 2 小题，每小题 6 分，共 12 分）','求函数 = 22 − 8 ln − 32 + 16的极值，并判断是极大值还是极小值.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,24,24,'essay','五、证明题（本大题共 1 小题，每小题 7 分，共 7 分）','已知函数 在 0,1 上连续，在 0,1 内可导，当 ∈ 0,1 时，都有 '' ≤ ，且 0 1 () = 0，证明： （1）存在0 ∈ 0,1 ，使得 0 = 0； （2）不等式2 0 + 2(1) ≤ 2.',NULL,NULL,NULL,7,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 山东 高等数学III 2025 (24 题, published=1) · 中文卷解析·选择9·材料0·主观14·暂缺0·共24 =====
SET @pid := (SELECT id FROM paper WHERE province='山东' AND subject='高等数学III' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数 = 1 9−2的定义域为（ ）.',JSON_ARRAY('A. [ − 3，3]','B. ( − 3，3)','C. (3， + ∞)','D. ( − ∞，3)'),NULL,NULL,3,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','下列函数是单调递增函数的是（ ）.',JSON_ARRAY('A. ||','B. C.2','D. cos'),NULL,NULL,3,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','当 → 0 时，下列函数为无穷大量的是（ ）.',JSON_ARRAY('A. arctan','B. sin','C. 1','D. 3'),NULL,NULL,3,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','函数 = 3+2 +5 的水平渐近线是（ ）.',JSON_ARRAY('A. =− 5','B. =− 3','C. = 1','D. = 3'),NULL,NULL,3,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知()在 = 2 处可导且lim ℎ→0 (2+4ℎ)−(2+ℎ) ℎ = 6，则''(2) =（ ）.',JSON_ARRAY('A. −6','B. −2','C. 2','D. 6'),NULL,NULL,3,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知函数 = ()由方程 = ln − 所确定，则 =（ ）.',JSON_ARRAY('A. 1− +','B. 1+ +','C. 1− −','D. 1+ −'),NULL,NULL,3,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知1 = 0 4 sin2，2 = 0 4 sin3，3 = 0 4 sin4，则下列不等式成立的是（ ）.',JSON_ARRAY('A. I1 ≤ I2 ≤ I3','B. I2 ≤ I3 ≤ I1','C. I3 ≤ I2 ≤ I1','D. I2 ≤ I1 ≤ I3 2'),NULL,NULL,3,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知()在 R 上连续且 0 1 2 = 3，则 0 1 () =（ ）.',JSON_ARRAY('A. 3 2','B. 1 2','C. 3','D. 6'),NULL,NULL,3,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知()在[0,2]上连续且 0 2 () + ''() = 1，则(2) =（ ）.',JSON_ARRAY('A. 1','B. 1 2','C. 2','D. 4'),NULL,NULL,3,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 3 分，共 30 分）','已知() = 0 cos ( + )2，则''() =（ ）.',JSON_ARRAY('A. 2cos42 − cos2','B. cos2 − 2cos42','C. cos42 − cos2','D. cos2 − cos42'),NULL,NULL,3,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 lim →∞ + 2 = 5， lim →∞ − = 8，则 lim →∞ = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知极限lim →0 sin 3 = 2 + ，则 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知(0，0)是曲线 = ln(1 + ) + 2的拐点，则 = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知 5 + cos3是()的原函数，则''() = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 5 小题，每小题 3 分，共 15 分）','已知()在 R 上连续且∫1 2 (2) = 1，则∫0 1 [( + 1) + ()] = .',NULL,NULL,NULL,3,'reveal_only'),
(@pid,16,16,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求极限lim →2 2+5−3 −2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,17,17,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求极限lim →0 −sin−cos sin2 .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,18,18,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','已知函数() = (−1)2 + ， < 0 3 ， = 0 ( + 1) 1 ， > 0 在点 = 0 处连续，求、的值.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,19,19,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求函数 = 3 + = + 在 = 0 处的切线方程.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,20,20,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求不定积分∫ 32+6+1 32+1 . 3',NULL,NULL,NULL,6,'reveal_only'),
(@pid,21,21,'calc','三、计算题（本大题共 6 小题，每小题 6 分，共 36 分）','求定积分∫0 1 ln (1+ ) 1+ .',NULL,NULL,NULL,6,'reveal_only'),
(@pid,22,22,'essay','四、应用题（本大题共 2 小题，每小题 6 分，共 12 分）','计算由曲线 = ( − 1)2， ≤ 1 4 − 4， > 1 和 = 2所围成的图形的面积.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,23,23,'essay','四、应用题（本大题共 2 小题，每小题 6 分，共 12 分）','求函数 = (2 − 3)2 − 22 + 4的极值，并判断是极大值还是极小值.',NULL,NULL,NULL,6,'reveal_only'),
(@pid,24,24,'essay','五、证明题（本大题共１小题，每小题 7 分，共 7 分）','已知函数()在[0，2]处连续，在(0，2)处二阶可导且(0) = 1，(1) = 2，(2) = 4，证明：∃ ∈ (0，2)，使得''''() = 1.',NULL,NULL,NULL,7,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

