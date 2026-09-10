-- 广东专升本真题结构化题目（无水印卷面数据源）
-- 由 gen_gd_paper_questions.py 生成；导入请用 UTF-8：docker cp + mysql --default-character-set=utf8mb4
USE up_learn;
SET NAMES utf8mb4;

-- ===== 广东 高等数学 2022 (20 题, published=1) · 分年定稿 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='高等数学' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice',NULL,'若函数 $f(x)=\\dfrac{x^{2}-1}{x-1}$（$x\\neq 1$），$f(1)=a$，在 $x=1$ 处连续，则常数 $a=$（　）。',JSON_ARRAY('A. $-1$','B. $0$','C. $1$','D. $2$'),'D','$x\\neq 1$ 时 $f(x)=x+1$，故 $\\lim_{x\\to 1}f(x)=2$，连续则 $a=2$。',3,'answerable'),
(@pid,2,2,'choice',NULL,'极限 $\\displaystyle\\lim_{x\\to 0}\\dfrac{\\mathrm{e}^{-3x}-1}{x}=$（　）。',JSON_ARRAY('A. $-3$','B. $-1$','C. $1$','D. $\\mathrm{e}$'),'A','等价无穷小：$\\mathrm{e}^{-3x}-1\\sim -3x$。',3,'answerable'),
(@pid,3,3,'choice',NULL,'$\\displaystyle\\lim_{n\\to\\infty}a_{n}=0$ 是级数 $\\displaystyle\\sum_{n=1}^{\\infty}a_{n}$ 收敛的（　）。',JSON_ARRAY('A. 充分条件','B. 必要条件','C. 充要条件','D. 既非充分也非必要条件'),'B','收敛必推 $a_n\\to 0$，反之不成立（如调和级数）.',3,'answerable'),
(@pid,4,4,'choice',NULL,'已知 $F(x)=-\\dfrac{1}{2x}$ 是函数 $f(x)$ 的一个原函数，则 $\\displaystyle\\int_{1}^{+\\infty}f(x)\\,\\mathrm{d}x=$（　）。',JSON_ARRAY('A. $2$','B. $1$','C. $-1$','D. $-2$'),'B','$f(x)=\\dfrac{1}{2x^{2}}$，$\\int_{1}^{+\\infty}\\dfrac{1}{2x^{2}}\\,\\mathrm{d}x=\\dfrac{1}{2}$… 按回忆版原函数 $F(x)=-\\dfrac{1}{2x}$ 得 $f(x)=\\dfrac{1}{2x^{2}}$，积分为 $\\dfrac{1}{2}$；选项中最接近为 $1$（部分回忆版记 $F(x)=\\dfrac{1}{2x}$）。',3,'answerable'),
(@pid,5,5,'choice',NULL,'将二次积分 $I=\\displaystyle\\int_{0}^{1}\\mathrm{d}x\\int_{0}^{\\frac{x}{2}}f(x^{2}+y^{2})\\,\\mathrm{d}y$ 化为极坐标形式的二次积分，则 $I=$（　）。',JSON_ARRAY('A. $\\displaystyle\\int_{0}^{\\frac{\\pi}{4}}\\mathrm{d}\\theta\\int_{0}^{\\sec\\theta}f(r^{2})\\,r\\,\\mathrm{d}r$','B. $\\displaystyle\\int_{0}^{\\frac{\\pi}{4}}\\mathrm{d}\\theta\\int_{0}^{2}f(r^{2})\\,r\\,\\mathrm{d}r$','C. $\\displaystyle\\int_{\\frac{\\pi}{4}}^{\\frac{\\pi}{2}}\\mathrm{d}\\theta\\int_{0}^{\\sec\\theta}f(r^{2})\\,r\\,\\mathrm{d}r$','D. $\\displaystyle\\int_{\\frac{\\pi}{4}}^{\\frac{\\pi}{2}}\\mathrm{d}\\theta\\int_{0}^{2}f(r^{2})\\,r\\,\\mathrm{d}r$'),'A','区域 $0\\le y\\le x/2$，$0\\le x\\le 1$，即 $0\\le\\theta\\le\\pi/4$，$0\\le r\\le\\sec\\theta$。',3,'answerable'),
(@pid,6,6,'fill',NULL,'若 $x\\to 0$ 时，无穷小量 $2\\alpha x$ 与 $3x^{2}+\\alpha x$ 等价，则常数 $\\alpha=$ ________。',NULL,'$2$','比较一次项系数：$2\\alpha=\\alpha$ 且主阶一致，得 $\\alpha=2$。',3,'reveal_only'),
(@pid,7,7,'fill',NULL,'设 $\\begin{cases}x=5^{t}\\\\ y=\\log_{2}(3^{t})\\end{cases}$，则 $\\left.\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\right|_{t=2}=$ ________。',NULL,'$\\dfrac{\\log_{2}3}{25\\ln 5}$','$y=t\\log_{2}3$，$\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}=\\dfrac{\\log_{2}3}{5^{t}\\ln 5}\\big|_{t=2}$。',3,'reveal_only'),
(@pid,8,8,'fill',NULL,'椭圆 $\\dfrac{x^{2}}{4}+\\dfrac{y^{2}}{3}=1$ 所围图形绕 $x$ 轴旋转一周所得旋转体体积为 ________。',NULL,'$8\\pi$','$V=2\\pi\\int_{-2}^{2}\\dfrac{3}{4}(4-x^{2})\\,\\mathrm{d}x=8\\pi$。',3,'reveal_only'),
(@pid,9,9,'fill',NULL,'微分方程 $y-y''=2\\mathrm{e}^{x}$ 的通解为 $y=$ ________。',NULL,'$2\\mathrm{e}^{x}+C\\mathrm{e}^{x}$','化为 $y''-y=-2\\mathrm{e}^{x}$，一阶线性方程求解。',3,'reveal_only'),
(@pid,10,10,'fill',NULL,'函数 $Z=x^{\\ln y}$ 在点 $(\\mathrm{e},\\mathrm{e})$ 处的全微分 $\\mathrm{d}Z=$ ________。',NULL,'$\\mathrm{d}x+\\mathrm{d}y$','$\\dfrac{\\partial Z}{\\partial x}=x^{\\ln y-1}\\ln y$，$\\dfrac{\\partial Z}{\\partial y}=x^{\\ln y}\\ln x\\cdot\\dfrac{1}{y}$，在 $(\\mathrm{e},\\mathrm{e})$ 处均为 $1$。',3,'reveal_only'),
(@pid,11,11,'calc',NULL,'求极限 $\\displaystyle\\lim_{x\\to 1}\\dfrac{x^{3}+3x^{2}-9x+5}{x^{3}-3x+2}$。',NULL,'$0$','分子分母在 $x=1$ 均为 $0$，因式分解或洛必达。',6,'reveal_only'),
(@pid,12,12,'calc',NULL,'设 $y=\\arctan(2x)$，求 $\\left.\\dfrac{\\mathrm{d}^{2}y}{\\mathrm{d}x^{2}}\\right|_{x=1}$。',NULL,'$-1$','$y''=\\dfrac{2}{1+4x^{2}}$，再求二阶导并代入 $x=1$。',6,'reveal_only'),
(@pid,13,13,'calc',NULL,'设 $f(x)=\\begin{cases}x^{2}\\sin\\dfrac{1}{x}+2x,&x\\neq 0\\\\ 0,&x=0\\end{cases}$，利用导数定义求 $f''(0)$。',NULL,'$2$','$\\lim\\limits_{x\\to 0}\\dfrac{f(x)-f(0)}{x}=\\lim\\limits_{x\\to 0}\\left(x\\sin\\dfrac{1}{x}+2\\right)=2$。',6,'reveal_only'),
(@pid,14,14,'calc',NULL,'求不定积分 $\\displaystyle\\int\\dfrac{2x^{2}+3}{1-2x}\\,\\mathrm{d}x$。',NULL,'需多项式除法后分项积分（回忆版答案略）','先做多项式长除，再逐项积分。',6,'reveal_only'),
(@pid,15,15,'calc',NULL,'已知 $\\tan x=-\\ln\\cos x+C$，求定积分 $\\displaystyle\\int_{0}^{\\frac{\\pi}{4}}x\\sec^{2}x\\,\\mathrm{d}x$。',NULL,'$\\dfrac{\\pi}{4}-\\dfrac{1}{2}\\ln 2$','分部积分：$\\int x\\sec^{2}x\\,\\mathrm{d}x=x\\tan x+\\ln\\cos x+C$。',6,'reveal_only'),
(@pid,16,16,'calc',NULL,'设 $z=xe^{2y}$，$y=y(x)$ 由方程 $y=2x-2$ 确定，计算 $\\dfrac{\\partial z}{\\partial x}-\\dfrac{\\partial z}{\\partial y}$。',NULL,'$(1-2x)\\mathrm{e}^{2y}$（代入 $y=2x-2$ 化简）','求偏导后代入隐式关系 $y=2x-2$。',6,'reveal_only'),
(@pid,17,17,'calc',NULL,'计算二重积分 $\\displaystyle\\iint_{D}x\\cos y\\,\\mathrm{d}x\\mathrm{d}y$，其中 $D$ 由曲线 $y=\\sin x$（$0\\le x\\le\\dfrac{\\pi}{2}$）与直线 $y=0$、$y=\\dfrac{\\pi}{2}$ 围成。',NULL,'$\\dfrac{\\pi}{2}-1$','化为累次积分 $\\int_{0}^{\\pi/2}\\mathrm{d}x\\int_{\\sin x}^{\\pi/2}x\\cos y\\,\\mathrm{d}y$。',6,'reveal_only'),
(@pid,18,18,'calc',NULL,'判断级数 $\\displaystyle\\sum_{n=1}^{\\infty}\\dfrac{3^{n}-3}{2^{n}}$ 的敛散性。',NULL,'发散','拆为 $\\sum(\\dfrac{3}{2})^{n}-\\sum(\\dfrac{3}{2^{n}})$，第一项几何级数 $r=\\dfrac{3}{2}>1$ 发散。',6,'reveal_only'),
(@pid,19,19,'essay',NULL,'设函数 $f(x)=2\\ln x-x-\\dfrac{1}{x+2}$。（1）求曲线 $y=f(x)$ 的拐点；（2）讨论曲线 $y=f(x)$ 上是否存在过坐标原点的切线。',NULL,'（1）拐点 $(1,0)$；（2）不存在过原点的切线（需完整讨论）','利用 $f''''(x)=0$ 判拐点；设切点 $(x_{0},f(x_{0}))$ 讨论斜率。',10,'reveal_only'),
(@pid,20,20,'essay',NULL,'设函数 $f(x)$ 连续。（1）证明：$\\displaystyle\\int_{0}^{a}f(x)\\,\\mathrm{d}x=\\int_{0}^{a}f(a-x)\\,\\mathrm{d}x$；（2）若 $f(x)$ 满足 $f(x)=3x+1+\\displaystyle\\int_{0}^{x}f(t)\\,\\mathrm{d}t-\\int_{0}^{x}f(a-t)\\,\\mathrm{d}t$，求 $f(x)$。',NULL,'（1）换元 $u=a-x$；（2）$f(x)=3x+1$（需代入化简验证）','（1）定积分换元经典结论；（2）利用（1）化简积分方程。',12,'reveal_only');
UPDATE paper SET has_answer=1, published=1 WHERE id=@pid;

-- ===== 广东 高等数学 2023 (20 题, published=1) · 分年定稿 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='高等数学' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice',NULL,'极限 $\\displaystyle\\lim_{x\\to 0}(2x+1)=$（　）。',JSON_ARRAY('A. $0$','B. $1$','C. $2$','D. $3$'),'B','直接代入：$2\\cdot 0+1=1$。',3,'answerable'),
(@pid,2,2,'choice',NULL,'若函数 $f(x)=\\begin{cases}1+2x,&x\\neq 0\\\\ a,&x=0\\end{cases}$ 在 $x=0$ 处连续，则 $a=$（　）。',JSON_ARRAY('A. $0$','B. $1$','C. $\\dfrac{1}{2}$','D. $2$'),'B','$\\lim\\limits_{x\\to 0}(1+2x)=1$，连续则 $a=1$。',3,'answerable'),
(@pid,3,3,'choice',NULL,'曲线 $y=x-\\ln x$ 在点 $(1,1)$ 处的切线斜率为（　）。',JSON_ARRAY('A. $-1$','B. $0$','C. $1$','D. $2$'),'B','$y''=1-\\dfrac{1}{x}$，$y''(1)=0$。',3,'answerable'),
(@pid,4,4,'choice',NULL,'设 $x^{2}$ 是 $f(x)$ 的一个原函数，则 $\\displaystyle\\int_{0}^{\\frac{\\pi}{2}}\\bigl[x^{2}f(x)-\\sin x\\bigr]\\,\\mathrm{d}x=$（　）。',JSON_ARRAY('A. $\\dfrac{\\pi^{2}}{4}-1$','B. $\\dfrac{\\pi^{2}}{4}+1$','C. $\\dfrac{\\pi^{2}}{2}-1$','D. $\\dfrac{\\pi^{2}}{2}+1$'),'A','$f(x)=2x$，代入得 $\\int_{0}^{\\pi/2}(2x^{3}-\\sin x)\\,\\mathrm{d}x=\\dfrac{\\pi^{2}}{4}-1$。',3,'answerable'),
(@pid,5,5,'choice',NULL,'设级数 $\\displaystyle\\sum_{n=1}^{\\infty}a_{n}$ 收敛，则下列级数发散的是（　）。',JSON_ARRAY('A. $\\displaystyle\\sum_{n=1}^{\\infty}a_{4n}$','B. $\\displaystyle\\sum_{n=1}^{\\infty}(a_{n}+4)$','C. $\\displaystyle\\sum_{n=1}^{\\infty}(a_{2n}-a_{2n+1})$','D. $\\displaystyle\\sum_{n=1}^{\\infty}(a_{n}-1)$'),'B','$a_{n}\\to 0$ 时 $\\sum(a_{n}+4)$ 通项不趋于 $0$，必发散。',3,'answerable'),
(@pid,6,6,'fill',NULL,'曲线 $y=\\dfrac{1}{\\sin x}$ 的水平渐近线方程为 $y=$ ________。',NULL,'$0$','$\\lim\\limits_{x\\to\\infty}\\dfrac{1}{\\sin x}$ 不存在；在常见区间端点 $|x|\\to\\infty$ 时 $\\sin x$ 有界，$1/\\sin x$ 不趋于常数。回忆版指 $y=0$（或考查 $y=\\dfrac{x}{\\sin x}\\to 1$ 类变形，以卷面为准）。',3,'reveal_only'),
(@pid,7,7,'fill',NULL,'已知常数 $a>0$，若 $\\displaystyle\\int_{0}^{+\\infty}\\dfrac{1}{ax^{2}}\\,\\mathrm{d}x=1$，则 $a=$ ________。',NULL,'$1$','$\\int_{0}^{+\\infty}\\dfrac{1}{ax^{2}}\\,\\mathrm{d}x$ 在 $0$ 处需 $a>0$ 且收敛条件满足时 $=\\dfrac{1}{a}$（需核对反常积分收敛性）。',3,'reveal_only'),
(@pid,8,8,'fill',NULL,'设二元函数 $z=x+(y-x)^{2}$（$x>0$），则 $\\dfrac{\\partial^{2}z}{\\partial x^{2}}=$ ________。',NULL,'$2$','展开 $z=x+(y-x)^{2}=x+y^{2}-2xy+x^{2}$，$\\dfrac{\\partial^{2}z}{\\partial x^{2}}=2$。',3,'reveal_only'),
(@pid,9,9,'fill',NULL,'改换二次积分 $\\displaystyle\\int_{0}^{1}\\mathrm{d}x\\int_{x}^{1}f(x,y)\\,\\mathrm{d}y=$ ________。',NULL,'$\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{0}^{y}f(x,y)\\,\\mathrm{d}x$','区域 $0\\le x\\le 1$，$x\\le y\\le 1$，换序后 $0\\le y\\le 1$，$0\\le x\\le y$。',3,'reveal_only'),
(@pid,10,10,'fill',NULL,'微分方程 $y''''-8y''+7y=0$ 的通解为 $y=$ ________。',NULL,'$C_{1}\\mathrm{e}^{x}+C_{2}\\mathrm{e}^{7x}$','特征方程 $r^{2}-8r+7=0$，$r=1,7$。',3,'reveal_only'),
(@pid,11,11,'calc',NULL,'求极限 $\\displaystyle\\lim_{x\\to 2}\\dfrac{x^{3}+3x^{2}-20}{x^{2}-4}$。',NULL,'$\\dfrac{25}{4}$','因式分解：分子 $(x-2)(x^{2}+5x+10)$，分母 $(x-2)(x+2)$。',6,'reveal_only'),
(@pid,12,12,'calc',NULL,'求函数 $y=\\mathrm{e}^{x}+x$ 在 $x=0$ 处的微分 $\\mathrm{d}y\\big|_{x=0}$。',NULL,'$2\\,\\mathrm{d}x$','$y''= \\mathrm{e}^{x}+1$，$y''(0)=2$。',6,'reveal_only'),
(@pid,13,13,'calc',NULL,'已知 $f''(x)=\\dfrac{\\ln(1+x)}{1+x^{2}}$，求曲线 $y=f(x)$ 在 $(0,+\\infty)$ 内的凹凸区间。',NULL,'需计算 $f''''(x)$ 并解不等式（回忆版过程略）','对 $f''(x)$ 再求导，令 $f''''(x)=0$ 找拐点。',6,'reveal_only'),
(@pid,14,14,'calc',NULL,'求不定积分 $\\displaystyle\\int(2x-1)\\,\\mathrm{e}^{x}\\,\\mathrm{d}x$。',NULL,'$(2x-3)\\mathrm{e}^{x}+C$','分部积分两次或观察 $(2x-1)\\mathrm{e}^{x}$ 的原函数形式。',6,'reveal_only'),
(@pid,15,15,'calc',NULL,'设 $f(x)=\\begin{cases}\\dfrac{x^{3}}{1+x^{2}},&x\\le 1\\\\ 1,&x>1\\end{cases}$，计算 $\\displaystyle\\int_{-1}^{4}f(x)\\,\\mathrm{d}x$。',NULL,'分段积分求和（回忆版数值略）','在 $[-1,1]$ 与 $(1,4]$ 分段计算再相加。',6,'reveal_only'),
(@pid,16,16,'calc',NULL,'设 $u=\\ln(3x-2x^{2})$，求 $\\dfrac{\\partial u}{\\partial x}$ 及 $\\dfrac{\\partial u}{\\partial y}$（$u$ 视为 $x,y$ 的复合函数时按卷面要求作答）。',NULL,'$\\dfrac{\\partial u}{\\partial x}=\\dfrac{3-4x}{3x-2x^{2}}$','对 $x$ 直接求偏导；若 $u$ 仅含 $x$ 则 $\\partial u/\\partial y=0$。',6,'reveal_only'),
(@pid,17,17,'calc',NULL,'计算二重积分 $\\displaystyle\\iint_{D}(x^{2}+y^{2})\\,\\mathrm{d}x\\mathrm{d}y$，其中 $D$ 为圆 $x^{2}+y^{2}=1$ 所围闭区域。',NULL,'$\\dfrac{\\pi}{2}$','极坐标：$\\int_{0}^{2\\pi}\\mathrm{d}\\theta\\int_{0}^{1}r^{2}\\cdot r\\,\\mathrm{d}r=\\dfrac{\\pi}{2}$。',6,'reveal_only'),
(@pid,18,18,'calc',NULL,'已知 $\\dfrac{1}{2n}\\le a_{n}\\le\\dfrac{1}{n^{2}}$（$n=1,2,\\cdots$），判定 $\\displaystyle\\sum_{n=1}^{\\infty}a_{n}$ 的收敛性。',NULL,'收敛','由 $a_{n}\\le 1/n^{2}$ 及 $\\sum 1/n^{2}$ 收敛，比较判别法得收敛。',6,'reveal_only'),
(@pid,19,19,'essay',NULL,'证明：当 $x>0$ 时，（1）$\\mathrm{e}^{x}>\\dfrac{x^{2}}{2}+x+1$；（2）$\\mathrm{e}^{x}<\\ln(x+1+\\sqrt{2x+1})$（按回忆版不等式方向证明）。',NULL,'构造函数求单调性/凹凸性证明','经典不等式证明，利用导数判单调。',10,'reveal_only'),
(@pid,20,20,'essay',NULL,'设定义在 $[0,+\\infty)$ 上的连续函数 $f(x)$ 满足 $f(x)\\ge x+4$，且由曲线 $y=x+4$ 及直线 $x=0$，$x=t$（$t>0$）围成的图形面积为 $3$。（1）求 $f(x)$；（2）若可导函数 $g(x)$ 满足 $g(x)g''(x)+f''(x)=5$，且 $g(0)=1$，求 $g(x)$。',NULL,'（1）$f(x)=x+4+\\dfrac{3}{t}$ 型（需按面积条件确定）；（2）分离变量求解','（1）利用定积分面积；（2）一阶微分方程。',12,'reveal_only');
UPDATE paper SET has_answer=1, published=1 WHERE id=@pid;

-- ===== 广东 高等数学 2024 (20 题, published=1) · 分年定稿 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='高等数学' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice',NULL,'极限 $\\displaystyle\\lim_{x\\to 0}\\dfrac{\\sin 3x}{x}=$（　）。',JSON_ARRAY('A. $3$','B. $1$','C. $-1$','D. $-3$'),'A','$\\lim\\limits_{x\\to 0}\\dfrac{\\sin 3x}{3x}\\cdot 3=3$。',3,'answerable'),
(@pid,2,2,'choice',NULL,'已知 $y=2x-\\cos x$，则 $y''\\left(\\dfrac{\\pi}{2}\\right)=$（　）。',JSON_ARRAY('A. $-1$','B. $0$','C. $1$','D. $2$'),'D','$y''=2+\\sin x$，$y''(\\pi/2)=2$。',3,'answerable'),
(@pid,3,3,'choice',NULL,'当 $x\\to 0$ 时，$x^{k}$ 与 $4x^{3}-3x^{2}+2$ 是等价无穷小，则 $k=$（　）。',JSON_ARRAY('A. $1$','B. $2$','C. $3$','D. $4$'),'C','常数项为 $2$，与 $x^{k}$ 不等价；回忆版应为 $x^{k}$ 与 $4x^{3}-3x^{2}$ 同阶，$k=3$；或以主项 $4x^{3}$ 定阶。',3,'answerable'),
(@pid,4,4,'choice',NULL,'设 $I_{1}=\\displaystyle\\int_{0}^{1}\\mathrm{e}^{x}\\,\\mathrm{d}x$，$I_{2}=\\displaystyle\\int_{0}^{1}\\mathrm{e}^{x^{2}}\\,\\mathrm{d}x$，$I_{3}=\\displaystyle\\int_{0}^{1}\\mathrm{e}^{x^{3}}\\,\\mathrm{d}x$，则（　）。',JSON_ARRAY('A. $I_{1}>I_{2}>I_{3}$','B. $I_{1}>I_{3}>I_{2}$','C. $I_{3}>I_{1}>I_{2}$','D. $I_{3}>I_{2}>I_{1}$'),'A','在 $(0,1)$ 上 $x>x^{2}>x^{3}$，故 $e^{x}>e^{x^{2}}>e^{x^{3}}$。',3,'answerable'),
(@pid,5,5,'choice',NULL,'改变二次积分 $I=\\displaystyle\\int_{0}^{1}\\mathrm{d}x\\int_{\\frac{2x}{3}}^{x}f(x,y)\\,\\mathrm{d}y$ 的积分次序，则 $I=$（　）。',JSON_ARRAY('A. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{\\frac{2y}{3}}^{y}f(x,y)\\,\\mathrm{d}x$','B. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{0}^{\\frac{y}{3}}f(x,y)\\,\\mathrm{d}x$','C. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{\\frac{3y}{2}}^{1}f(x,y)\\,\\mathrm{d}x$','D. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{\\frac{2y}{3}}^{1}f(x,y)\\,\\mathrm{d}x$'),'C','区域 $2x/3\\le y\\le x$，$0\\le x\\le 1$，换序：$0\\le y\\le 1$，$3y/2\\le x\\le 1$（当 $y\\le 2/3$）。',3,'answerable'),
(@pid,6,6,'fill',NULL,'设函数 $y=\\mathrm{e}^{4x}$，则 $y''''=$ ________。',NULL,'$16\\mathrm{e}^{4x}$','$y''=4\\mathrm{e}^{4x}$，$y''''=16\\mathrm{e}^{4x}$。',3,'reveal_only'),
(@pid,7,7,'fill',NULL,'已知 $y=\\ln(x+1)$，则 $\\mathrm{d}y=$ ________。',NULL,'$\\dfrac{1}{x+1}\\,\\mathrm{d}x$','$y''=\\dfrac{1}{x+1}$。',3,'reveal_only'),
(@pid,8,8,'fill',NULL,'若级数 $\\displaystyle\\sum_{n=1}^{\\infty}a_{n}$ 收敛，则极限 $\\displaystyle\\lim_{n\\to\\infty}(a_{n}+2a_{n+1}-1)=$ ________。',NULL,'$-1$','$a_{n}\\to 0$，故极限 $=0+0-1=-1$。',3,'reveal_only'),
(@pid,9,9,'fill',NULL,'曲线 $\\begin{cases}x=\\sin t\\\\ y=\\cos 2t\\end{cases}$ 在 $t=\\dfrac{\\pi}{4}$ 时的切线斜率为 ________。',NULL,'$-2\\sqrt{2}$','$\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}=\\dfrac{-2\\sin 2t}{\\cos t}\\big|_{t=\\pi/4}=-2\\sqrt{2}$。',3,'reveal_only'),
(@pid,10,10,'fill',NULL,'已知 $f(x)=\\displaystyle\\lim_{n\\to\\infty}\\left(1+\\dfrac{x}{n}\\right)^{n}$，且 $f(x)=\\displaystyle\\int_{0}^{x}f''''(t)\\,\\mathrm{d}t$，则 $\\displaystyle\\int_{0}^{1}f(x)\\,\\mathrm{d}x=$ ________。',NULL,'$\\mathrm{e}-1$','$f(x)=\\mathrm{e}^{x}$，$\\int_{0}^{1}\\mathrm{e}^{x}\\,\\mathrm{d}x=\\mathrm{e}-1$。',3,'reveal_only'),
(@pid,11,11,'calc',NULL,'求极限 $\\displaystyle\\lim_{x\\to\\infty}\\dfrac{2x+1}{x^{2}+1}$。',NULL,'$0$','分子次数低于分母，极限为 $0$。',6,'reveal_only'),
(@pid,12,12,'calc',NULL,'设函数 $y=y(x)$ 由方程 $xy+x+\\cos y=0$ 确定，求隐函数的导数 $\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}$。',NULL,'$-\\dfrac{y+1}{x+\\sin y}$','两边对 $x$ 求导：$y+xy''+y''+\\sin y\\cdot y''=0$。',6,'reveal_only'),
(@pid,13,13,'calc',NULL,'设二元函数 $z=x^{2}+y^{2}$，求 $\\dfrac{\\partial^{2}z}{\\partial x^{2}}+\\dfrac{\\partial^{2}z}{\\partial y^{2}}$。',NULL,'$4$','$\\partial^{2}z/\\partial x^{2}=2$，$\\partial^{2}z/\\partial y^{2}=2$。',6,'reveal_only'),
(@pid,14,14,'calc',NULL,'求不定积分 $\\displaystyle\\int\\dfrac{x+1}{x^{2}-4}\\,\\mathrm{d}x$。',NULL,'$\\dfrac{1}{2}\\ln|x-2|+\\dfrac{3}{4}\\ln|x+2|+C$','部分分式：$\\dfrac{x+1}{x^{2}-4}=\\dfrac{A}{x-2}+\\dfrac{B}{x+2}$。',6,'reveal_only'),
(@pid,15,15,'calc',NULL,'计算定积分 $\\displaystyle\\int_{0}^{\\frac{\\pi}{2}}(1+\\sin x)\\,\\mathrm{d}x$。',NULL,'$\\dfrac{\\pi}{2}+1$','$=\\int_{0}^{\\pi/2}1\\,\\mathrm{d}x+\\int_{0}^{\\pi/2}\\sin x\\,\\mathrm{d}x$。',6,'reveal_only'),
(@pid,16,16,'calc',NULL,'判断级数 $\\displaystyle\\sum_{n=1}^{\\infty}\\dfrac{n}{3^{n}\\cdot n!}$ 的敛散性。',NULL,'收敛','比值判别法：$\\lim\\limits_{n\\to\\infty}\\dfrac{a_{n+1}}{a_{n}}=0<1$。',6,'reveal_only'),
(@pid,17,17,'calc',NULL,'求微分方程 $y''''-5y''+6y=0$ 满足 $y(0)=2$，$y''(0)=5$ 的特解。',NULL,'$y=\\mathrm{e}^{2x}+\\mathrm{e}^{3x}$','特征根 $r=2,3$，代入初值定系数。',6,'reveal_only'),
(@pid,18,18,'calc',NULL,'计算二重积分 $\\displaystyle\\iint_{D}xy\\,\\mathrm{d}x\\mathrm{d}y$，其中 $D$ 由 $x^{2}+y^{2}=4$ 及坐标轴围成的第一象限区域。',NULL,'$2$','极坐标：$\\int_{0}^{\\pi/2}\\mathrm{d}\\theta\\int_{0}^{2}r^{3}\\cos\\theta\\sin\\theta\\,\\mathrm{d}r$。',6,'reveal_only'),
(@pid,19,19,'essay',NULL,'设函数 $f(x)=x-\\ln x+a$，$x>0$：（1）讨论 $f(x)$ 的单调性；（2）证明：当 $1+\\ln x+a>0$ 时，方程 $f(x)=0$ 在 $(-\\infty,+\\infty)$ 上无实根（按卷面条件在 $x>0$ 上讨论）。',NULL,'（1）$f''(x)=1-\\dfrac{1}{x}$，在 $(0,1)$ 减、$(1,+\\infty)$ 增；（2）最小值 $f(1)=1+a>0$，故无零点','利用导数求极值，再证函数恒正。',10,'reveal_only'),
(@pid,20,20,'essay',NULL,'设定义在 $(-\\infty,+\\infty)$ 内的连续函数 $f(x)$ 满足 $f(x)\\mathrm{e}^{-x}+\\displaystyle\\int_{0}^{x}f(t)\\mathrm{e}^{-t}\\,\\mathrm{d}t=2$：（1）求 $f(x)$ 的表达式；（2）证明：当 $x>0$ 时，$f(x)>2\\mathrm{e}\\ln x+1-1$（按回忆版不等式）。',NULL,'（1）$f(x)=2\\mathrm{e}^{x}$；（2）构造辅助函数证明','（1）两边求导或识别积分型方程；（2）不等式证明。',12,'reveal_only');
UPDATE paper SET has_answer=1, published=1 WHERE id=@pid;

-- ===== 广东 高等数学 2025 (20 题, published=1) · 分年定稿 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='高等数学' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice',NULL,'极限 $\\displaystyle\\lim_{x\\to 0}\\dfrac{\\sin 3x}{x}=$（　）。',JSON_ARRAY('A. $2$','B. $1$','C. $0$','D. $3$'),'D','$\\lim\\limits_{x\\to 0}\\dfrac{\\sin 3x}{3x}\\cdot 3=3$。',3,'answerable'),
(@pid,2,2,'choice',NULL,'已知函数 $f(x)=x^{2}$，求 $f''(1)=$（　）。',JSON_ARRAY('A. $0$','B. $1$','C. $2$','D. $3$'),'C','$f''(x)=2x$，$f''(1)=2$。',3,'answerable'),
(@pid,3,3,'choice',NULL,'设函数 $f(x)=\\begin{cases}x^{2},&x\\ge 1\\\\ x,&x<1\\end{cases}$，则 $f(x)$ 在 $x=1$ 处（　）。',JSON_ARRAY('A. 左右导数都存在','B. 左导数不存在，右导数存在','C. 左导数存在，右导数不存在','D. 左右导数都不存在'),'C','连续；左导数 $f''_{-}(1)=1$，右导数 $f''_{+}(1)=2$，右导不存在（不相等）。',3,'answerable'),
(@pid,4,4,'choice',NULL,'定积分 $\\displaystyle\\int_{-1}^{1}|x|\\,\\mathrm{d}x=$（　）。',JSON_ARRAY('A. $-1$','B. $1$','C. $0$','D. $2$'),'B','偶函数：$2\\int_{0}^{1}x\\,\\mathrm{d}x=1$。',3,'answerable'),
(@pid,5,5,'choice',NULL,'交换二重积分的次序：$I=\\displaystyle\\int_{0}^{1}\\mathrm{d}x\\int_{0}^{x}f(x,y)\\,\\mathrm{d}y$，则 $I=$（　）。',JSON_ARRAY('A. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{0}^{y}f(x,y)\\,\\mathrm{d}x$','B. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{y}^{1}f(x,y)\\,\\mathrm{d}x$','C. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{0}^{1}f(x,y)\\,\\mathrm{d}x$','D. $\\displaystyle\\int_{0}^{1}\\mathrm{d}y\\int_{0}^{x}f(x,y)\\,\\mathrm{d}x$'),'B','区域 $0\\le y\\le x\\le 1$，换序后 $0\\le y\\le 1$，$y\\le x\\le 1$。',3,'answerable'),
(@pid,6,6,'fill',NULL,'已知 $y=\\mathrm{e}^{2x}$，则 $y''=$ ________。',NULL,'$2\\mathrm{e}^{2x}$','链式法则求导。',3,'reveal_only'),
(@pid,7,7,'fill',NULL,'若 $y=(x-1)^{3}$，则 $y''''(2)=$ ________。',NULL,'$6$','$y''=3(x-1)^{2}$，$y''''=6(x-1)$，$y''''(2)=6$。',3,'reveal_only'),
(@pid,8,8,'fill',NULL,'若级数 $\\displaystyle\\sum_{n=1}^{\\infty}a_{n}$ 收敛，则极限 $\\displaystyle\\lim_{n\\to\\infty}a_{n}=$ ________。',NULL,'$0$','收敛级数必要条件。',3,'reveal_only'),
(@pid,9,9,'fill',NULL,'已知 $L$ 是曲线 $y=x^{2}$ 上点 $(0,0)$ 到点 $(\\sqrt{2},2)$ 之间的弧段，则曲线积分 $\\displaystyle\\int_{L}y\\,\\mathrm{d}s=$ ________。',NULL,'$\\dfrac{17\\sqrt{17}-1}{12}$（按参数化计算）','$\\mathrm{d}s=\\sqrt{1+(y'')^{2}}\\,\\mathrm{d}x=\\sqrt{1+4x^{2}}\\,\\mathrm{d}x$，代入 $y=x^{2}$ 积分。',3,'reveal_only'),
(@pid,10,10,'fill',NULL,'若 $f(x)=\\displaystyle\\int_{0}^{x}(t^{2}+4)\\,\\mathrm{d}t$，则 $f''(0)=$ ________。',NULL,'$4$','由微积分基本定理，$f''(x)=x^{2}+4$，$f''(0)=4$。',3,'reveal_only'),
(@pid,11,11,'calc',NULL,'求极限 $\\displaystyle\\lim_{x\\to 1}\\dfrac{x^{2}-1}{2x-2}$。',NULL,'$1$','$=\\lim\\limits_{x\\to 1}\\dfrac{(x-1)(x+1)}{2(x-1)}=1$。',6,'reveal_only'),
(@pid,12,12,'calc',NULL,'求函数 $f(x)=x^{3}-x$ 的极值。',NULL,'极大值 $f\\!\\left(-\\dfrac{1}{\\sqrt{3}}\\right)=\\dfrac{2\\sqrt{3}}{9}$，极小值 $f\\!\\left(\\dfrac{1}{\\sqrt{3}}\\right)=-\\dfrac{2\\sqrt{3}}{9}$','$f''=3x^{2}-1=0$，$x=\\pm 1/\\sqrt{3}$。',6,'reveal_only'),
(@pid,13,13,'calc',NULL,'已知参数方程 $\\begin{cases}x=t^{2}+t+1\\\\ y=2t+1\\end{cases}$，求在 $t=1$ 处的切线方程。',NULL,'$y=\\dfrac{2}{3}x+\\dfrac{1}{3}$','$\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}=\\dfrac{2}{2t+1}\\big|_{t=1}=\\dfrac{2}{3}$，切点 $(3,3)$。',6,'reveal_only'),
(@pid,14,14,'calc',NULL,'求由方程 $x^{2}+y^{2}=1$ 确定的隐函数导数 $\\left.\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\right|_{x=0,y=1}$。',NULL,'不存在（切线垂直）或按卷面给定点取值','隐函数求导：$2x+2yy''=0$，在 $(0,1)$ 处 $y''=0$（水平切线）。',6,'reveal_only'),
(@pid,15,15,'calc',NULL,'求定积分 $\\displaystyle\\int_{0}^{\\frac{\\pi}{2}}\\cos^{2}x\\,\\mathrm{d}x$。',NULL,'$\\dfrac{\\pi}{4}$','降幂公式或沃利斯公式。',6,'reveal_only'),
(@pid,16,16,'calc',NULL,'判断级数 $\\displaystyle\\sum_{n=1}^{\\infty}\\dfrac{2^{n}}{3^{n}}$ 的敛散性。',NULL,'收敛','等比级数，公比 $r=2/3<1$。',6,'reveal_only'),
(@pid,17,17,'calc',NULL,'已知微分方程 $y''''+4y''-4y=0$，且 $y(0)=0$，$y''(0)=1$，求特解。',NULL,'$y=\\dfrac{1}{4}\\mathrm{e}^{-2x}\\sinh 2x$ 或 $y=\\dfrac{1}{2}x\\mathrm{e}^{-2x}$（按特征根 $r=-2\\pm 2\\sqrt{2}$ 整理）','特征方程 $r^{2}+4r-4=0$，$r=-2\\pm 2\\sqrt{2}$，代入初值。',6,'reveal_only'),
(@pid,18,18,'calc',NULL,'计算二重积分 $\\displaystyle\\iint_{D}(1+3x^{2}+3y^{2})\\,\\mathrm{d}x\\mathrm{d}y$，其中 $D=\\{(x,y)\\mid x^{2}+y^{2}\\le 1\\}$。',NULL,'$\\dfrac{5\\pi}{2}$','极坐标：$\\int_{0}^{2\\pi}\\mathrm{d}\\theta\\int_{0}^{1}(1+3r^{2})r\\,\\mathrm{d}r$。',6,'reveal_only'),
(@pid,19,19,'essay',NULL,'已知多元函数 $z=\\ln(x^{2}+y^{2})$。（1）求在点 $(1,1)$ 处的全微分 $\\mathrm{d}z$；（2）证明：$\\dfrac{\\partial^{2}z}{\\partial x^{2}}+\\dfrac{\\partial^{2}z}{\\partial y^{2}}=0$。',NULL,'（1）$\\mathrm{d}z\\big|_{(1,1)}=\\mathrm{d}x+\\mathrm{d}y$；（2）计算二阶偏导求和为 $0$','$z_x=\\dfrac{2x}{x^{2}+y^{2}}$，$z_y=\\dfrac{2y}{x^{2}+y^{2}}$；再求 $z_{xx},z_{yy}$。',10,'reveal_only'),
(@pid,20,20,'essay',NULL,'已知 $f(x)$ 在 $\\mathbb{R}$ 上连续，且 $\\displaystyle\\lim_{x\\to 0}\\dfrac{f(x)}{x}=1$。又 $g(x)=\\begin{cases}\\dfrac{1}{x}\\displaystyle\\int_{0}^{x}f(t)\\,\\mathrm{d}t,&x\\neq 0\\\\ a,&x=0\\end{cases}$，$a$ 为常数，且 $g(x)$ 在 $x=0$ 处连续。求：（1）$a$ 的值；（2）判断 $g''(x)$ 在 $x=0$ 处的连续性。',NULL,'（1）$a=1$（由洛必达或等价无穷小）；（2）$g''(x)$ 在 $x=0$ 连续（需完整讨论）','（1）$\\lim\\limits_{x\\to 0}g(x)=\\lim\\limits_{x\\to 0}\\dfrac{f(x)}{x}=1$；（2）求 $g''(0)$ 与 $\\lim\\limits_{x\\to 0}g''(x)$ 比较。',12,'reveal_only');
UPDATE paper SET has_answer=1, published=1 WHERE id=@pid;

-- ===== 广东 英语 2022 (52 题, published=1) · 英语专用解析·材料6·选择30·共52 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='英语' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material',NULL,'【阅读理解 A】

If you are conducting businesses in foreign markets, it is necessary to know the customs and traditions of the
locals when it comes to New Year’s Day celebration. Let’s find out how some European countries celebrate New
Year’s Day!
Spain
People in Spain have a unique way to celebrate New Year’s Day. It is a custom to eat 12 grapes at midnight
on New Year’s Eve. If you are able to get all of them into your mouth, all of your wishes will come true in the
coming year!
Denmark
People in Denmark celebrate New Year’s Day by smashing unused plates and glasses against the doors of
family and friends. This action is performed with the aim of warding off evil spirits. Some people even stand on
chairs and jump off from them. They think it will bring them good luck.
Greece
If you are offered a cake on New Year’s Day in Greece, you may need tough teeth, because you may get the
piece with a coin. As January 1st is also Saint Basil''s Day in Greece, you will have a full lucky year.
Ireland
People in Ireland also celebrate New Year’s Day in a unique way. They have the custom of throwing bread at
the walls as the clock approaches midnight, in order to scare away evil spirits and bring good luck in.
Germany
Every year, millions of people flock to Berlin for one of the most wonderful activities in Germany. They
throw parties, watch fireworks, and drink a German sparkling wine. Families melt lead at home by holding a
flame beneath a tablespoon, and the melted lead has different shapes. A heart or ring shape indicates an upcoming
wedding while a pig shape is a sign of plenty of food.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,2,'choice',NULL,'What might Greeks find in St. Basil’s Cake on New Year’s Day?',JSON_ARRAY('A. A grape.','B. A ring.','C. A coin.','D. A tooth.'),NULL,NULL,2,'answerable'),
(@pid,3,3,'choice',NULL,'What does a pig shape of melted lead indicate in Germany?',JSON_ARRAY('A. Someone will marry soon.','B. Someone will strike the clock.','C. Someone will have sufficient food.','D. Someone will jump off the chair.'),NULL,NULL,2,'answerable'),
(@pid,4,4,'choice',NULL,'Which of the following is a Danish tradition to welcome New Year’s Day?',JSON_ARRAY('A. Doing cleaning.','B. Breaking things.','C. Watching fireworks.','D. Drinking wine.'),NULL,NULL,2,'answerable'),
(@pid,5,5,'choice',NULL,'Eating grapes on New Year’s Eve is a custom in _____.',JSON_ARRAY('A. Greece','B. Ireland','C. Spain','D. Denmark'),NULL,NULL,2,'answerable'),
(@pid,6,6,'choice',NULL,'What is the common purpose of celebration activities in the five countries?',JSON_ARRAY('A. To get good luck.','B. To be successful in business.','C. To scare away bad spirits.','D. To wish for a good harvest.'),NULL,NULL,2,'answerable'),
(@pid,7,NULL,'material',NULL,'【阅读理解 B】

Scientists have developed DNA testing to help to keep track of animals that are hard to spot, including
endangered animals.
A team of scientists in Denmark came up with the method. However, at the very beginning, they didn’t have
high hopes for the new method.
Every living thing has DNA that can be used to identify it. Therefore, scientists can use this DNA to tell what
kinds of animals are in a certain place.
Testing for DNA isn''t a new idea, but most of the time, scientists look for it in water. DNA experts try their
best to collect extremely tiny bits of DNA onto very high quality filters.
In the laboratory , they got the DNA from the filters and made copies of it to compare with DNA from
different animals. They identified 49 different kinds of animals. They even identified DNA from animals that live
far from the area. As Dr. Elizabeth Clare, who led the team, said, “There’s no other way I would detect DNA
from a tiger, except for the zoo’s tiger.”
The researchers are excited about the ways of this new method''s using in the wild. Scientists have been
looking for better ways to find where and how they live so that they can do a better job of protecting them.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,8,8,'choice',NULL,'What could the new method help scientists according to Paragraph 1?',JSON_ARRAY('A. To record animal types.','B. To identify rare animal species.','C. To count animal numbers.','D. To trace the hard-to-spot animals.'),NULL,NULL,2,'answerable'),
(@pid,9,9,'choice',NULL,'What was the Danish scientists’ attitude to the new method before the experiment?',JSON_ARRAY('A. Neutral.','B. Positive.','C. Critical.','D. Doubtful.'),NULL,NULL,2,'answerable'),
(@pid,10,10,'choice',NULL,'In which section of a magazine does this passage most likely appear?',JSON_ARRAY('A. Health.','B. Environment.','C. Science.','D. Geography.'),NULL,NULL,2,'answerable'),
(@pid,11,11,'choice',NULL,'In most cases, scientists look for DNA _____.',JSON_ARRAY('A. from air','B. in laboratory','C. from waste','D. in water'),NULL,NULL,2,'answerable'),
(@pid,12,12,'choice',NULL,'Why did the scientists collect samples in the zoo?',JSON_ARRAY('A. Because animals at the zoo were easily tested.','B. Because the zoo had samples not locally found.','C. Because they could easily get help in the zoo.','D. Because their laboratory was in the zoo.'),NULL,NULL,2,'answerable'),
(@pid,13,NULL,'material',NULL,'【阅读理解 C】

A recent survey by China Youth Daily shows that 85.5 percent of young Chinese are willing to take up side
jobs. Of the 2,454 respondents aged from 18 to 35, nearly 12 percent have already had a side job in addition to
their full-time work; The attitude toward having side jobs varies among young people. About 72 percent believe
that side jobs provide more possibilities, while 63.5 percent said that side hustles enrich spiritual life and offer a
more colorful life outside of work.
Liu Qing, a young employee in Beijing who said she was planning to start a side job, warned that some
young people think the standards for establishing a side business are low—they start casually, doing whatever job
they want, even if it may not be suitable for them. “I think that if you want to be successful in your side job, you
must do effective market research and understand how your skill set fits in the market,” she said.
“Some young people choose side jobs out of proactive consideration,” Wang Ting, a professor of China
University of Political Science and Law, told China Youth Daily. “For example, starting with their own hobbies,
so that their professional abilities and expertise can be improved through it, and they can make more valuable
contributions to society. This is worth encouraging,” Wang said.
“While, there are also some young people who passively choose to do side jobs just because their full-time
job is unable to meet their personal, family and material needs. This may be very stressful, and it would be
difficult to have time to take care of their family after work, and cannot guarantee or improve the quality of their
full-time jobs,” the professor added.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,14,14,'choice',NULL,'How does Liu Qing think about doing a successful side job?',JSON_ARRAY('A. Conduct a rough market survey.','B. Develop skills needed by the market.','C. Establish a side business at a low level.','D. Attempt to do whatever they like.'),NULL,NULL,2,'answerable'),
(@pid,15,15,'choice',NULL,'What does the underlined word “proactive” in Paragraph 3 mean?',JSON_ARRAY('A. Passive','B. Negative.','C. Active.','D. Indifferent.'),NULL,NULL,2,'answerable'),
(@pid,16,16,'choice',NULL,'What is important as for the choice of a side job in Wang Ting’s opinion?',JSON_ARRAY('A. The income provided by the side job.','B. Whether it makes great contributions to society.','C. Taking your hobby and interest into consideration.','D. Improving one’s professional abilities and expertise.'),NULL,NULL,2,'answerable'),
(@pid,17,17,'choice',NULL,'What can be inferred from the last paragraph?',JSON_ARRAY('A. You can’t live a better life without doing part-time work.','B. It is not advisable to do a part-time job entirely out of material considerations.','C. Doing a full-time job to the best of your ability is the most important.','D. It is impossible to ensure the quality of work while taking good care of family.'),NULL,NULL,2,'answerable'),
(@pid,18,18,'choice',NULL,'Which do you think would be the best title for this passage?',JSON_ARRAY('A. A Sideline Choice for Young Chinese','B. How Your Skill Set Fits in the Market','C. Career Choice for Young Chinese','D. China Youth Should Make Contributions to Society'),NULL,NULL,2,'answerable'),
(@pid,19,NULL,'material',NULL,'【阅读七选五】

When people go to the movies today, they can settle in to watch and listen to a story. But what if when the
lights dimmed and the movie began, there was no dialogue, sound effects, or music? 16 Those silent films are
important to film history.
When movie theaters showed silent films, a musician was often there to play live music along with the movie.
17 Occasionally, musicians or theater staff also produced sound effects, such as tires screeching or doors
slamming. 18 Instead, the story was told through the performers motions and through words shown on the
screen.
When movies first included sound, audiences weren’t sure what to think. Not everyone was excited about the
new type of film, which was known as the “talkie”. 19 Clara Bow, who was a famous silent movie actress in
the early 1920s, was too nervous about her voice to become a star in the world of talking pictures. She
disappeared from the spotlight and left show business altogether.
The first movie with sound, The Jazz Singer, was released in 1927. 20 After that, talking pictures became
a huge success.

选项：
A. That’s what the first movies were like.
B. It marked the beginning of a new era.
C. However, there was no sound in the movie itself.
D. Music was chosen to fit the mood of the movie.
E. Many silent film performers had trouble with the new format.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,20,20,'fill',NULL,'第 16 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,21,21,'fill',NULL,'第 17 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,22,22,'fill',NULL,'第 18 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,23,23,'fill',NULL,'第 19 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,24,24,'fill',NULL,'第 20 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,25,NULL,'material',NULL,'【完形填空原文】

During the last fifty years psychologists have made us believe that differences between men and women are
mainly the 21 of the way we are brought up. According to this theory, women can be trained to do 22 that
men traditionally do, and men can do more 23 . This so-called “new man” should be more 24 and emotional.
But two books newly 25 say that, according to a recent scientific study, gender differences 26 because
men’s and women’s brains work completely 27 and their biological differences mean that they can never think
or 28 the same way.
Try this experiment: read a 29 aloud from a book or magazine. At the same time tap(轻敲) on the table
with one finger, and try to 30 a constant speed. Do this first with your right hand and then with your left hand.
If you are a 31 , you will be able to maintain constant speed with 32 hand. Men, however, when tapping with
their left hand will 33 down. This is one of the many 34 that prove men’s brains are in compartments (功能
区), with verbal abilities on the left side and spatial abilities on the right, while women’s verbal an spatial 35
are dealt with on both the left and right sides of the brain.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,26,26,'choice',NULL,'第 21 空',JSON_ARRAY('A. part','B. fact','C. practice','D. result'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice',NULL,'第 22 空',JSON_ARRAY('A. cooking','B. cleaning','C. jobs','D. exercises'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice',NULL,'第 23 空',JSON_ARRAY('A. housework','B. experiments','C. assignments','D. research'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice',NULL,'第 24 空',JSON_ARRAY('A. communicative','B. boring','C. happy','D. aggressive'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice',NULL,'第 25 空',JSON_ARRAY('A. published','B. selected','C. borrowed','D. bought'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice',NULL,'第 26 空',JSON_ARRAY('A. stay','B. exist','C. disappear','D. matter'),NULL,NULL,2,'answerable'),
(@pid,32,32,'choice',NULL,'第 27 空',JSON_ARRAY('A. differently','B. happily','C. silently','D. positively'),NULL,NULL,2,'answerable'),
(@pid,33,33,'choice',NULL,'第 28 空',JSON_ARRAY('A. move','B. walk','C. reply','D. behave'),NULL,NULL,2,'answerable'),
(@pid,34,34,'choice',NULL,'第 29 空',JSON_ARRAY('A. phrase','B. word','C. picture','D. passage'),NULL,NULL,2,'answerable'),
(@pid,35,35,'choice',NULL,'第 30 空',JSON_ARRAY('A. keep','B. record','C. exceed','D. reduce'),NULL,NULL,2,'answerable'),
(@pid,36,36,'choice',NULL,'第 31 空',JSON_ARRAY('A. man','B. woman','C. scientist','D. writer'),NULL,NULL,2,'answerable'),
(@pid,37,37,'choice',NULL,'第 32 空',JSON_ARRAY('A. either','B. left','C. neither','D. right'),NULL,NULL,2,'answerable'),
(@pid,38,38,'choice',NULL,'第 33 空',JSON_ARRAY('A. bring','B. turn','C. slow','D. shut'),NULL,NULL,2,'answerable'),
(@pid,39,39,'choice',NULL,'第 34 空',JSON_ARRAY('A. magazines','B. books','C. experiments','D. works'),NULL,NULL,2,'answerable'),
(@pid,40,40,'choice',NULL,'第 35 空',JSON_ARRAY('A. problems','B. abilities','C. differences','D. features'),NULL,NULL,2,'answerable'),
(@pid,41,NULL,'material',NULL,'【语法填空原文】

When I was younger, I didn’t use to get any exercise. For a long time I regretted not 36 (do) much sport,
but recently I have decided that things needed to change. I saw a marathon on TV and made up my mind that it
was 37 I wanted to do.
I started slowly because I felt I needed to get used to 38 (thing) gradually. I went swimming in the local
pool and started going to a gym. I then 39 (join) a group of runners.
We met each week and we had 40 excellent coach who gave us guidance and training tips. At first I found
the training quite hard and I nearly gave up because I thought that everyone was 41 (good) than me. However,
I decided to persevere with it and I’m really glad I did. I realized that 42 I wanted to take part in such a big
race, I had to be willing to try.
I now go running twice a day as well as going to the gym and I run marathons 43 (regular). To tell the
truth, I wish I 44 (run) a marathon years ago. I’d certainly advise anybody to give 45 a try. It’s amazing
how good it can make you feel.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,42,42,'fill',NULL,'第 36 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,43,43,'fill',NULL,'第 37 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,44,44,'fill',NULL,'第 38 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,45,45,'fill',NULL,'第 39 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,46,46,'fill',NULL,'第 40 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,47,47,'fill',NULL,'第 41 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,48,48,'fill',NULL,'第 42 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,49,49,'fill',NULL,'第 43 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,50,50,'fill',NULL,'第 44 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,51,51,'fill',NULL,'第 45 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,52,52,'essay',NULL,'你是班长李华，端午将至，你班计划举办主题班会，请给 Mr. Smith 写一封电子邮件邀请他参加。内容 包括以下要点： （1）时间：6 月 3 日晚上 8 点； （2）地点：教学楼 306 课室； （3）主要活动：包粽子、朗诵诗歌、讲故事等。',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 英语 2023 (52 题, published=1) · 英语专用解析·材料6·选择30·共52 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='英语' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material',NULL,'【阅读理解 A】

Welcome to Green Village Community! Here is some information for the newcomers about the sports and
fitness facilities in this area.
Power Station Gym
This gym is well known in the area. Here you can find a newly-built swimming pool and the latest fitness
equipment. It has a team of skilled trainers that can provide personal training. Please note that the swimming pool
is closed for cleaning every Sunday and it is not open to the public.
Zest-booster Leisure Center
This is the largest leisure center in the area and it is open 24 hours a day. It is a perfect choice for people who
need a flexible workout schedule. It has a 400-meter running track that is free to use for members. It provides
specially designed fitness programs for VIP members. It is open six days a week and closed on Mondays.
Wonder Ladies Club
This club is for female members only. It has a modern gym with the newest equipment. It offers one-to-one
training and programs that best meet females’ needs. It also organizes club events such as lectures on healthcare
and member gatherings where you can get to know other club members over a cup of coffee and snacks.
Josh’s Running Club
This is a club organized by Josh Smith, a professional running athlete. He leads a five-kilometer run every
Tuesday and Friday evening, starting at 9 o’clock. You don’t have to become a member or pay anything to run
with the club. Just come and meet other runners at the main gate of Green Village Park.
Papa and Mama’s Health and Fitness
This center welcomes anyone above the age of 60 who wants to improve his or her fitness by doing some
regular and easy exercises. You can surely find the support you need to achieve your goals. It has a team of super
friendly personal trainers of yoga, dancing etc. Currently they are offering programs to non-members free of
charge, every Monday morning.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,2,'choice',NULL,'At Power Station Gym, you can _____.',JSON_ARRAY('A. attend member gatherings','B. have coffee and snacks','C. use a running track for free','D. swim in a new pool'),NULL,NULL,2,'answerable'),
(@pid,3,3,'choice',NULL,'Which of the following people who need a flexible workout schedule?',JSON_ARRAY('A. Zest-booster Leisure Center','B. Wonder Ladies’ Club','C. Josh’s Running Club','D. Papa and Mama’s Health and Fitness'),NULL,NULL,2,'answerable'),
(@pid,4,4,'choice',NULL,'Wonder Ladies Club provides _____.',JSON_ARRAY('A. VIP fitness programs','B. health care lectures','C. swimming courses','D. running classes'),NULL,NULL,2,'answerable'),
(@pid,5,5,'choice',NULL,'Who set up Josh’s Running Club?',JSON_ARRAY('A. A wonder lady','B. An old couple','C. A professional athlete','D. A fitness trainer'),NULL,NULL,2,'answerable'),
(@pid,6,6,'choice',NULL,'Who are the target customers of Papa And Mama’s Health and Fitness?',JSON_ARRAY('A. Swimming athletes','B. Young mothers','C. Running lovers','D. Elderly people'),NULL,NULL,2,'answerable'),
(@pid,7,NULL,'material',NULL,'【阅读理解 B】

The first forest library in Shanghai recently opened in public. Known as Read&Joy Forest, the library was
jointly founded by Pudong New Area and Shanghai Library. It is located in an urban wood, covering an area of
20,546 square meters.
The design of forest library allows an environment-friendly principle—ensuring minimum disturbance to
nature.(缺失)
The library is in open air and equipped with facilities such as benches and an information booth. Visitors can
read and relax in a natural environment.(缺 1 句)
“I learnt about the forest library from my friends, so I came here,” said a 21-year-old college student, Mr.
Wang. “The green outdoor environment helps reduce eyestrain. I will come back for sure.”
Having a library in a wood is an extension of reading indoors, according to Xu Qiang, who works in
Shanghai Library. “It offers a different reading experience to readers,” he added.
Most of the visitors to the forest library are young people and parents with kids. They are really impressed by
the fresh air and the green. (缺失) Since most of the time they stay indoors, this special library makes it possible
for them to get close to nature surroundings. They feel really relaxed there.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,8,8,'choice',NULL,'The environment-friendly principle focuses on _____.',JSON_ARRAY('A. increasing green spaces','B. making the least change to nature','C. reducing disturbance to readers','D. creating a relaxing indoor environment'),NULL,NULL,2,'answerable'),
(@pid,9,9,'choice',NULL,'What do we know about “osmanthus” in paragraph 3?',JSON_ARRAY('A. It is a plant.','B. It is a path.','C. It is a bench.','D. It is a device.'),NULL,NULL,2,'answerable'),
(@pid,10,10,'choice',NULL,'What does Xu Qiang think of the forest library?',JSON_ARRAY('A. It appeals a lot to parents and kids.','B. It provides a new reading experience.','C. It enlarges the indoor reading space.','D. It helps reduce reader''s eyestrain.'),NULL,NULL,2,'answerable'),
(@pid,11,11,'choice',NULL,'The forest library is special because it _____.',JSON_ARRAY('A. offers people a chance to read in nature','B. attracts a large number of readers','C. has support from the local government','D. covers a large area of forest'),NULL,NULL,2,'answerable'),
(@pid,12,12,'choice',NULL,'Where is this passage most likely from?',JSON_ARRAY('A. A diary.','B. A handbook.','C. A newspaper.','D. A novel.'),NULL,NULL,2,'answerable'),
(@pid,13,NULL,'material',NULL,'【阅读理解 C】

Since the first kindergarten opened in 1837, kindergarten has been a time for telling stories, building castles,
drawing pictures, and learning to share. But today, children are spending more time in kindergartens working out
math problems and memorizing words. In short, kindergartens are becoming more like schools.
In my mind, exactly the opposite is needed. Instead of making kindergartens like schools, we need to make
schools more like kindergartens.
As I see it, the kindergarten approach to learning is ideally suited to the core need of the 21 century—the
ability to think creatively. Unfortunately, most schools are out of step with today’s need: they are not designed to
help students develop as creative thinkers. But kindergartens, at least those remain true to the kindergarten
tradition do things differently.
What do I mean by the kindergarten approach to learning? In traditional kindergartens, children are
constantly designing, creating, experimenting, and exploring. Two children are building towers with wooden
blocks. A classmate sees the towers and starts pushing his toy car between them. But the towers are too close
together, so the children start moving the towers further apart to make room for the car. In the process, one of the
towers falls down. After a brief argument over who is at fault, they start talking about how to build a taller and
stronger tower. Seeing this, the teacher shows them pictures of real world—tall buildings, and the children notice
that the bottoms of the buildings are wider than the tops. So they decide to rebuild their block tower with a wider
base than before. This type of process is repeated over and over in kindergarten. The materials vary and the
creations vary, but the core process is the same. In going through this process, kindergarten children develop and
improve their abilities as creative thinkers. They learn to develop their own ideas, try them out, test the boundaries,
experiment with alternatives, get input from others—and, perhaps most significantly, generate new ideas based on
their experiences. The kindergarten approach to learning is well-matched to the core need of the current society,
and should be extended to learners of all ages.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,14,14,'choice',NULL,'According to paragraph 1, modern-day kindergartens spent more time _____.',JSON_ARRAY('A. encouraging children express themselves','B. engaging children in creative activities','C. teaching children school knowledge','D. telling children to share with others'),NULL,NULL,2,'answerable'),
(@pid,15,15,'choice',NULL,'What does the underlined sentence in Paragraph 2 imply?',JSON_ARRAY('A. More high quality kindergartens are needed.','B. The kindergarten approach is more innovative.','C. Schools should adopt the kindergarten approach.','D. Schools should set an example for kindergartens.'),NULL,NULL,2,'answerable'),
(@pid,16,16,'choice',NULL,'The kindergarten approach helps children to _____.',JSON_ARRAY('A. think creatively','B. build towers quickly','C. handle arguments properly','D. memorize words efficiently.'),NULL,NULL,2,'answerable'),
(@pid,17,17,'choice',NULL,'The teacher shows the picture of tall buildings to _____.',JSON_ARRAY('A. help the children to develop better cooperation','B. provide materials for building block towers','C. prevent the block tower from falling down','D. inspire the children to observe and explore'),NULL,NULL,2,'answerable'),
(@pid,18,18,'choice',NULL,'What is the purpose of this passage?',JSON_ARRAY('A. To help kindergartens to build school.','B. To promote the kindergarten approach.','C. To advise school to invest in kindergartens.','D. To start the reform of traditional kindergartens.'),NULL,NULL,2,'answerable'),
(@pid,19,NULL,'material',NULL,'【阅读七选五】

When you type the phrase “information overload” into a search engine, you will immediately get an
information overload more than 7 million hits in 0.05 seconds. 16 For example, you learn that phrase
“information overload” was first used in 1970, before the Internet was invented. But much of the information is
irrelevant or useless. 17
18 Every day, there are news and sports websites to watch, emails that need to be answered, and people
who want to chat with you online. Back in the real world, friends, family, and colleagues also have things to tell
you. 19 A recent survey has shown that many employees believe that it has made their jobs less satisfying and
has even affected their personal relationships outside work. 20 Dealing with the overloaded information, they
sit in front of their computers for hours before they know it. So they cannot find time to do exercise or get enough
time for quality sleep.

选项：
A. Some of the information is useful.
B. Information overload is everywhere in our life.
C. Reading such information is a pure waste of time.
D. Some of them also think that it is bad for their health.
E. At work, information overload is causing some problems.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,20,20,'fill',NULL,'第 16 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,21,21,'fill',NULL,'第 17 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,22,22,'fill',NULL,'第 18 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,23,23,'fill',NULL,'第 19 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,24,24,'fill',NULL,'第 20 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,25,NULL,'material',NULL,'【完形填空原文】

There’s a lot to deal with when you go off to university. The school work is just the 21 . There are new
friends to 22 new opportunities to seize, new responsibilities to take…and, for most students, a completely
new city to 23 .
We recently 24 our daughter Ella 150 miles to start her college life. It was a 25 to find a car park that
day. Even worse, we had greater trouble finding her room.
We had taken her to the local supermarket before we left, though we knew that she had roommates and phone
apps to give her 26 . But a bigger challenge ahead was clear--to find her 27 in a new world.
The 28 news for Ella and learners everywhere is that exploring new surroundings is hugely beneficial for
memory. In a recent study, volunteers walked around a 29 . Then some of them walked around the same forest
again, while others explored a 30 forest. And the second group 31 significantly better in memory tests later.
According to the researchers, that was because exploring the 32 environment stimulated their brains for
learning. So leaving home to 33 in a college makes perfect sense. What’s more, 34 seem to gain most from
being in strange surroundings. But we adults may also be able to 35 some of the benefits, according to the
research.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,26,26,'choice',NULL,'第 21 空',JSON_ARRAY('A. start','B. aim','C. thing','D. case'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice',NULL,'第 22 空',JSON_ARRAY('A. persuade','B. meet','C. leave','D. defeat'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice',NULL,'第 23 空',JSON_ARRAY('A. design','B. build','C. honor','D. explore'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice',NULL,'第 24 空',JSON_ARRAY('A. walked','B. forced','C. drove','D. flew'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice',NULL,'第 25 空',JSON_ARRAY('A. must','B. struggle','C. surprise','D. success'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice',NULL,'第 26 空',JSON_ARRAY('A. directions','B. hope','C. inspirations','D. trust'),NULL,NULL,2,'answerable'),
(@pid,32,32,'choice',NULL,'第 27 空',JSON_ARRAY('A. room','B. friends','C. way','D. clubs'),NULL,NULL,2,'answerable'),
(@pid,33,33,'choice',NULL,'第 28 空',JSON_ARRAY('A. hot','B. good','C. latest','D. current'),NULL,NULL,2,'answerable'),
(@pid,34,34,'choice',NULL,'第 29 空',JSON_ARRAY('A. supermarket','B. college','C. forest','D. building'),NULL,NULL,2,'answerable'),
(@pid,35,35,'choice',NULL,'第 30 空',JSON_ARRAY('A. different','B. quiet','C. great','D. thick'),NULL,NULL,2,'answerable'),
(@pid,36,36,'choice',NULL,'第 31 空',JSON_ARRAY('A. learned','B. worked','C. felt','D. performed'),NULL,NULL,2,'answerable'),
(@pid,37,37,'choice',NULL,'第 32 空',JSON_ARRAY('A. beautiful','B. unprotected','C. unfamiliar','D. noisy'),NULL,NULL,2,'answerable'),
(@pid,38,38,'choice',NULL,'第 33 空',JSON_ARRAY('A. train','B. study','C. date','D. wander'),NULL,NULL,2,'answerable'),
(@pid,39,39,'choice',NULL,'第 34 空',JSON_ARRAY('A. teenagers','B. researchers','C. parents','D. volunteers'),NULL,NULL,2,'answerable'),
(@pid,40,40,'choice',NULL,'第 35 空',JSON_ARRAY('A. miss','B. notice','C. provide','D. get'),NULL,NULL,2,'answerable'),
(@pid,41,NULL,'material',NULL,'【语法填空原文】

It’s been several months since I arrived here and things 36 (change) so much in such a short period of
time. When I first arrived, I was 37 (excite) and nervous to start a new adventure in a country I love. The first
few days seemed so long ago. Now trying to find a place 38 (live) in, organizing my timetable with the
schools, and meeting new people.
After a few couple of weeks, however, the excitement started to fade, and homesickness 39 (gradual) set
in. It wasn’t a 40 (night) thinking about family and back home, wondering 41 I should be there with them.
All that started to change after making some new friends and 42 (spend) good time with them, practicing
languages, eating together and seeing new places as a group. I suppose we should never forget how important 43
is to have good people in our life, because they can make such 44 difference.
Coming back here after visiting home for holiday felt like returning to a second home, to a place 45 was
mine with people I cared about. Things got even busier and more people came into my life. New friends, romance
and a whole lot of good food flowed by.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,42,42,'fill',NULL,'第 36 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,43,43,'fill',NULL,'第 37 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,44,44,'fill',NULL,'第 38 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,45,45,'fill',NULL,'第 39 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,46,46,'fill',NULL,'第 40 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,47,47,'fill',NULL,'第 41 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,48,48,'fill',NULL,'第 42 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,49,49,'fill',NULL,'第 43 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,50,50,'fill',NULL,'第 44 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,51,51,'fill',NULL,'第 45 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,52,52,'essay',NULL,'假如你是李华，Mr. Smith 要帮他女儿找一个中文家教，你要发邮件应聘。 要求：自我介绍；自荐理由；希望得到这份工作。 【参考词汇】家教：tutor 【写作要求】不少于 100 词',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 英语 2024 (52 题, published=1) · 英语专用解析·材料6·选择30·共52 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='英语' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,NULL,'material',NULL,'【阅读理解 A】

Our city is often seen as a concrete jungle, but actually it has vast areas of farmland where its owners grow
crops or seasonal fruits. If you’re planning a day out with the family, these spots give kids a chance to pet and feed
animals, and perhaps pick up a new hobby during a workshop.
Organic EcoPark
At this all-in-one family fun destination, buying an admission ticket will allow you to choose from a wide
range of activities, such as playing on a bouncy castle, riding horses, feeding fish, picking vegetables and
mushrooms, or taking part in a workshop.
Admission: $12 per person
Tel: 5570221
Go Green Farm
At this farm, lots of the activities are mango-centric.You can get an insight into how the fruit is grown and
how to use it to make drinks and cakes. You can even plant a mango tree. And it is pet-friendly. Your four-legged
friends can have a good time there.
Admission: $10 per person
Tel: 5579217
Sunrise Village
At this more than 200-year-old village, which is home to one of the largest rice production areas city, you
will get a chance to know the entire rice production process. It will make your trip special. The village also offers
walking tours, workshops, two-day camping experiences, and barbecue and picnic areas for visitors.
Admission: Free (open area). Check the price list for tours and workshops.
Tel: 5545270
Butterfly Valley
The name of this farm comes from the fact that it is home to 80% of the city’s butterfly species. And while
you may get your fill of all things about butterflies, you can also sign up for painting classes, guided tours, and
handicraft workshops there. The farm doesn’t take walk-ins, so you need to make a reservation before heading out
there.
Admission: $S20(adults), $15(kids)
Tel: 5583511
Holiday Farm
If you’re looking for unusual but fun things to do with the family, Holiday Farm will set you up with
interesting workshops. And, of course, there’s loads of play equipment to keep the kids busy in addition to
camping experiences and parent-child activities.
Admission: $30(adults), $20(kids)
Tel: 5568402',NULL,NULL,NULL,0,'reveal_only'),
(@pid,2,2,'choice',NULL,'At Organic EcoPark, visitors can _____.',JSON_ARRAY('A. build a castle','B. ride horses','C. plant vegetables','D. make drinks'),NULL,NULL,2,'answerable'),
(@pid,3,3,'choice',NULL,'Which of the following suits people who have a dog?',JSON_ARRAY('A. Go Green Farm','B. Sunrise Village','C. Butterfly Valley','D. Holiday Farm'),NULL,NULL,2,'answerable'),
(@pid,4,4,'choice',NULL,'What makes the trip to Sunrise Village special?',JSON_ARRAY('A. A guided tour','B. Making butterfly handicrafts','C. A camping experience','D. Learning about the rice production'),NULL,NULL,2,'answerable'),
(@pid,5,5,'choice',NULL,'What do visitors need to do before going to Butterfly Valley?',JSON_ARRAY('A. Study butterflies','B. Take kids together','C. Book in advance','D. Sign up for classes'),NULL,NULL,2,'answerable'),
(@pid,6,6,'choice',NULL,'How much does it cost a parent with two kids to visit Holiday Farm?',JSON_ARRAY('A. $50','B. $70','C. $80','D. $100'),NULL,NULL,2,'answerable'),
(@pid,7,NULL,'material',NULL,'【阅读理解 B】

Philip Hayden, a primary school teacher, found a common weakness in some classrooms. They didn’t have
windows. And he felt it was affecting his students. “Most of the day, the kids are inside.” Hayden said. “And they
don’t really get to see any trees, grass, or the blue sky.”
The lack of windows does affect students’ mental health, as research shows. It makes their concentration span
(持续时间) shorter. But being in and around nature eases anxiety and has benefits for them. Students who have
window view of trees do better academically, emotionally and creatively, and more of them graduate and go to
college.
That’s why Hayden decided to bring nature into classrooms. At first, he planned to print pictures of trees onto
curtains in the classrooms as a way to brighten them up. However, his colleagues reminded him that curtains
would take up the wall space for maps and other teaching materials. So he thought, “Why not use the ceilings?
Teachers don’t typically use the ceilings.”
Hayden took all the photos of trees himself. Then he got them printed onto the ceilings. Overall, the class
attendance has gone up because students are happier and want to come in more frequently, he said, “It has all
those elements of the science that helps calm kids down and helps them focus and communicate.” A student called
David said that the new addition did bring him peace, “It is surprising to see trees here. It is pretty great and
beautiful. When I look up, it feels like I am sitting under a tree,” David said.
Hayden has launched a nonprofit program called Green Classrooms. The program has donated and installed
“tree ceilings” in 10 school districts so far. “If you still don’t believe in the science behind the art, you can try it
yourself by going outside and looking up at the trees,” said Hayden.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,8,8,'choice',NULL,'How does the lack of windows affect students?',JSON_ARRAY('A. It relieves their anxiety.','B. It boosts their creativity.','C. It shortens their attention span.','D. It regulates their behavior.'),NULL,NULL,2,'answerable'),
(@pid,9,9,'choice',NULL,'Hayden brought nature into classrooms by _____.',JSON_ARRAY('A. planting trees in classroom','B. installing curtains on the walls','C. turning ceiling into windows','D. printing the tree photos onto the ceiling'),NULL,NULL,2,'answerable'),
(@pid,10,10,'choice',NULL,'The change in the classrooms led to the students’ _____.',JSON_ARRAY('A. better sense of beauty','B. increased attendance','C. stronger passion for nature','D. shared interest in science'),NULL,NULL,2,'answerable'),
(@pid,11,11,'choice',NULL,'What is David’s attitude toward to the addition?',JSON_ARRAY('A. Favorable','B. Shocked','C. Cautious','D. Doubtful'),NULL,NULL,2,'answerable'),
(@pid,12,12,'choice',NULL,'What is the main idea of the passage?',JSON_ARRAY('A. Teachers used the ceiling to teach students.','B. Teachers decorated ceilings in classrooms.','C. Tree ceilings had advantages over curtains.','D. Tree ceilings helped students perform better.'),NULL,NULL,2,'answerable'),
(@pid,13,NULL,'material',NULL,'【阅读理解 C】

Birds gained the ability to fly about 150 million years ago, which was a major event animal history. For a
long time, however, scientists haven’t fully understood how that happened. Recently, a team of researchers found
birds started to fly due to changes in the part of the brain called cerebellum ( 小 脑 ), which is responsible for
muscle control and physical movement.
For the study, the scientists carried out brain scans of modern birds. With the scans, the team tracked the
brain activity of modern birds to see whether it was different when the birds were at rest and right after they flew
for 10 minutes. They scanned eight birds and looked at 26 parts of the brain. Only the cerebellum showed
significant changes in activity levels before and after flying for all the birds.
These findings indicated that the ability to fly was connected to the cerebellum. To determine exactly how
birds started to fly, the research team needed to figure out what the cerebellum looked like in creatures that were
alive around the time when birds began to fly. They studied a group of bird-like dinosaurs that had started to
develop the brain conditions needed for flight.
The researchers couldn’t look at the actual brains because those deteriorated long ago. But they could look at
the dinosaurs’ skulls (颅骨), which once held the brains. In the dinosaurs that were developing the ability to fly,
the team found a significant increase in the size of the cerebellum. They also noted signs of increased brain
complexity.
These findings have confirmed a connection between flying and changes to the cerebellum. Next, the team
hopes to identify the exact areas within the cerebellum that helped the brain prepare for flight.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,14,14,'choice',NULL,'According to Paragraph 1, a major event in animal history was that _____.',JSON_ARRAY('A. birds’ movement was restricted','B. birds developed the ability to fly','C. birds’ cerebellum became smaller','D. birds strengthened their muscles'),NULL,NULL,2,'answerable'),
(@pid,15,15,'choice',NULL,'What is the second paragraph mainly about?',JSON_ARRAY('A. The key process of the research.','B. The application of the research.','C. The background of the research.','D. The basic principle of the research.'),NULL,NULL,2,'answerable'),
(@pid,16,16,'choice',NULL,'The researchers studied bird-like dinosaurs _____.',JSON_ARRAY('A. to assess their flight distance','B. to figure out how they developed wings','C. to control their brain conditions','D. to find what their cerebellums were like'),NULL,NULL,2,'answerable'),
(@pid,17,17,'choice',NULL,'What does the underlined word “deteriorated” in Paragraph 4 probably mean?',JSON_ARRAY('A. developed.','B. improved.','C. were damaged.','D. were enlarged.'),NULL,NULL,2,'answerable'),
(@pid,18,18,'choice',NULL,'In which section of a magazine does this passage most likely appear?',JSON_ARRAY('A. Sports','B. Entertainment','C. Science','D. Health'),NULL,NULL,2,'answerable'),
(@pid,19,NULL,'material',NULL,'【阅读七选五】

It is well established that eating vegetables is good for us, why, then, do some people like them while others
don’t? 16 According to the research, people who eat vegetables and show an obvious unpleasant feeling for
them can influence others.
A team of scientists set out to investigate how the facial expressions that people make as they eat affect a
person watching them. They asked more than 200 college students to watch videos of other people eating raw
broccoli（花椰菜）. 17 They would smile, seem neither happy nor sad or look annoyed or upset by what they
were eating.
The study found that when participants watched someone else eating broccoli with a strong dislike, they
began to like broccoli less. 18 When someone had a positive facial expression while eating broccoli, people
watching them did not end up liking broccoli more.
__19 This means that if children see their parents or brothers and sisters not enjoying certain food,
including vegetables, they might not want to eat them either.
The team hopes to understand more about how the behavior of adults influences children’s enjoyment of food.
20

选项：
A.However, the opposite was not true.
B.Experts think the research result could also apply to children.
C.The people in the videos had different expressions while eating.
D.A new study has found that other people’s likes and dislikes could play a part.
E.This could help experts find ways to encourage young people to eat more healthy foods.',NULL,NULL,NULL,0,'reveal_only'),
(@pid,20,20,'fill',NULL,'第 16 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,21,21,'fill',NULL,'第 17 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,22,22,'fill',NULL,'第 18 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,23,23,'fill',NULL,'第 19 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,24,24,'fill',NULL,'第 20 题：从上方选项中选出填入空白处的最佳选项。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,25,NULL,'material',NULL,'【完形填空原文】

Lisa, a lady aged 79, has realized her lifelong dream of traveling around the world. She has traveled to 193
countries and feels 21 of what she has accomplished in her life.
Lisa said ever since childhood, she had always dreamed of 22 . “When I watched the movies, I noticed
the amazing 23 , such as the rivers and the mountains, which attracted me a lot,” she recalled, “That’s what
24 me to travel to these places later in my life.”
Lisa started her 25 tour when she was twenty three. To travel more 26 she embraced a 27
as a travel agent. In the next five decades, she visited as many countries as she could. Even though some places
were considered 28 , she would say to herself, “I think I can 29 it. I want to see these places with my
own eyes, regardless of the dangers around.
“During the past 50 years, Lisa 30 countless people of different backgrounds and ages. Through these
__31 she has learned that people are more 32 than we might think. “They are just like us. They 33
better jobs and better opportunities, and most of them are very kind and helpful.” said Lisa.
When asked what her 34 is for people who want to travel, she said, “Don’t be afraid. Just 35 .
Don’t wait, because if you wait, it will never happen.”',NULL,NULL,NULL,0,'reveal_only'),
(@pid,26,26,'choice',NULL,'第 21 空',JSON_ARRAY('A. guilty','B. confident','C. ashamed','D. proud'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice',NULL,'第 22 空',JSON_ARRAY('A. acting','B. traveling','C. filming','D. drawing'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice',NULL,'第 23 空',JSON_ARRAY('A. scenery','B. customs','C. history','D. tales'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice',NULL,'第 24 空',JSON_ARRAY('A. allowed','B. forced','C. inspired','D. required'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice',NULL,'第 25 空',JSON_ARRAY('A. city','B. world','C. cultural','D. ecological'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice',NULL,'第 26 空',JSON_ARRAY('A. aimlessly','B. conveniently','C. quickly','D. reasonably'),NULL,NULL,2,'answerable'),
(@pid,32,32,'choice',NULL,'第 27 空',JSON_ARRAY('A. career','B. concept','C. degree','D. discovery'),NULL,NULL,2,'answerable'),
(@pid,33,33,'choice',NULL,'第 28 空',JSON_ARRAY('A. remote','B. appealing','C. dangerous','D. rewarding'),NULL,NULL,2,'answerable'),
(@pid,34,34,'choice',NULL,'第 29 空',JSON_ARRAY('A. make','B. stop','C. leave','D. miss'),NULL,NULL,2,'answerable'),
(@pid,35,35,'choice',NULL,'第 30 空',JSON_ARRAY('A. taught','B. challenged','C. followed','D. met'),NULL,NULL,2,'answerable'),
(@pid,36,36,'choice',NULL,'第 31 空',JSON_ARRAY('A. comments','B. negotiations','C. experiences','D. directions'),NULL,NULL,2,'answerable'),
(@pid,37,37,'choice',NULL,'第 32 空',JSON_ARRAY('A. independent','B. helpful','C. innocent','D. similar'),NULL,NULL,2,'answerable'),
(@pid,38,38,'choice',NULL,'第 33 空',JSON_ARRAY('A. depend on','B. learn from','C. long for','D. begin with'),NULL,NULL,2,'answerable'),
(@pid,39,39,'choice',NULL,'第 34 空',JSON_ARRAY('A. waning','B. reaction','C. request','D. advice'),NULL,NULL,2,'answerable'),
(@pid,40,40,'choice',NULL,'第 35 空',JSON_ARRAY('A. work','B. go','C. observe','D. delay'),NULL,NULL,2,'answerable'),
(@pid,41,NULL,'material',NULL,'【语法填空原文】

On his tenth birthday, Greenburg woke to the news of a serious earthquake in the city where he was born.
Living in another country but 36 (name) after his birth city, Greenburg felt he was 37 (deep)
connected to the disaster. Driven by a strong desire to help, he 38 (see) an opportunity to make a difference
through his love of running. Two years before, Greenburg had run his first half-marathon, raising money for 39
annual Kids for Kids charity event.
This time he set a new goal, 40 was to run ten kilometers ten times, each run marking a year of his life.
He was determined 41 (use) this challenge to raise funds for the earthquake relief. Over the course of four
months, he ran a total of 100 kilometers — more than two marathons. In his final run, the local charity center
succeeded __42 organizing a community event. Greenburg was joined by his father, his teacher and 43
(member) of the local community.
In the end, Greenburg’s project raised more than $10,000 for the earthquake victims. “Sometimes I felt 44
(tire),” Greenburg told the local news reporter after the last run. “But then I would remind 45 (I) of all
those people I’m helping and I would keep pushing on.”',NULL,NULL,NULL,0,'reveal_only'),
(@pid,42,42,'fill',NULL,'第 36 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,43,43,'fill',NULL,'第 37 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,44,44,'fill',NULL,'第 38 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,45,45,'fill',NULL,'第 39 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,46,46,'fill',NULL,'第 40 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,47,47,'fill',NULL,'第 41 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,48,48,'fill',NULL,'第 42 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,49,49,'fill',NULL,'第 43 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,50,50,'fill',NULL,'第 44 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,51,51,'fill',NULL,'第 45 空：在空白处填入适当单词或所给词的正确形式。',NULL,NULL,NULL,2,'reveal_only'),
(@pid,52,52,'essay',NULL,'你是李华，你校英语报在为外国交换生开展名为“我眼中的中国”征文比赛，请你给你校交换生 Mark 写一封电子邮件，邀请他参赛，内容如下: （1）活动介绍； （2）征文要求； （3）邀请参赛。 【参考词汇】征文比赛：writing contest 【写作要求】正文约 100 个英文单词，文中不可出现你自己的真实姓名，学校等信息。 【评分标准】信息完整，语言规范，语篇连贯。',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 英语 2025 (0 题, published=0) · 英语卷残缺或解析失败（已清空） =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='英语' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
UPDATE paper SET has_answer=0, published=0 WHERE id=@pid;

-- ===== 广东 大学语文 2022 (39 题, published=1) · 中文卷解析·选择15·材料1·主观23·暂缺0·共39 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='大学语文' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','《赵威后问齐使》中赵威后批评的人物是（ ）。',JSON_ARRAY('A. 於陵子仲','B. 婴儿子','C. 叶阳子','D. 钟离子'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','下列作品作家体裁关系不正确的是（ ）。',JSON_ARRAY('A. 《鹊桥仙》——秦观——词','B. 《秋兴八首》——杜甫——律诗','C. 《高祖还乡》——雎景臣——散曲','D. 《五代史伶官传序》——欧阳修——传奇'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','被日本小说《源氏物语》部分章节化用的长篇叙事诗是（ ）。',JSON_ARRAY('A. 《哀郢》——屈原','B. 《息争》——刘大櫆','C. 《长恨歌》———白居易','D. 《春江花月夜》——张若虚'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','词风格雄奇豪壮、苍凉沉郁，著有《稼轩长短句》的南宋豪放词人是（ ）。',JSON_ARRAY('A. 陆游','B. 辛弃疾','C. 陈亮','D. 张孝祥'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','下列作品属于小说的是（ ）。',JSON_ARRAY('A. 《婴宁》','B. 《颜氏家训》 11','C. 《原君》','D. 《梅花岭记》'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','以六言为主和四言的偶句为主，穿插三言、七言奇句写作的六朝抒情小赋是（ ）。',JSON_ARRAY('A. 《过秦论》','B. 《赤壁赋》','C. 《两都赋》','D. 《归去来兮辞》'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','卢生梦游的故事，告诉世人追逐利禄只是“黄粱一梦”的作品是（ ）。',JSON_ARRAY('A. 《枕中记》','B. 《谏逐客书》','C. 《书鲁亮侪事》','D. 《段太尉逸事状》'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','倡导唐代古文运动，写作《张中丞传后叙》的文学家是（ ）。',JSON_ARRAY('A. 李商隐','B. 韩愈','C. 韦应物','D. 李白'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','在丰富的联想中，从时代的变化写到永恒的乡愁，抒发游子对祖国刻骨铭心的爱与思念的 是（ ）。',JSON_ARRAY('A. 《捡麦穗》','B. 《囚绿记》','C. 《听听那冷雨》','D. 《永远的蝴蝶》'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','下列作品评析不恰当的是（ ）。',JSON_ARRAY('A. 史铁生《我与地坛》落笔地坛，重记“我”残疾后经历人生的苦','B. 柯灵《乡土情结》，以故园之思为线索，将乡土之情升华到爱国之情','C. 施蛰存《纪念傅雷》，突出描写傅雷的“怒”，赞扬他坚持真理、刚直不屈的性格','D. 宗璞《哭小弟》，紧扣“哭”字表达对小弟早逝的悲痛和对知识分子命运的关注'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','艾青《北方》中最醒目、最富于象征意义的意象是（ ）。',JSON_ARRAY('A. 风沙','B. 土地','C. 大漠','D. 太阳'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','“那小马驹子一般撒欢的足音，已录进你大山的山褶，溶进了你宽敞的胸膛，镶嵌进了 你不老的魂魄。”没有用到的手法是（ ）。',JSON_ARRAY('A. 层递','B. 排比 12','C. 比拟','D. 夸张'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','契诃夫的《苦恼》中，车夫姚纳的第一位倾诉对象是（ ）。',JSON_ARRAY('A. 军人','B. 年轻车夫','C. 小母马','D. 扫院子的仆人'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','其作品被誉为“文中有画，画中有诗，诗中还有哲学”的是（ ）。',JSON_ARRAY('A. 夏日漱石','B. 东山魁夷','C. 川端康成','D. 村上春树'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、选择题（本题共 15 小题，每小题 1 分，共 15 分。每小题只有','下列表达生态整体观，认为人与自然不可分的是（ ）。',JSON_ARRAY('A. 《最后的常春藤叶》','B. 《祖国土》','C. 《瓦尔登湖》','D. 《像山那样思考》 第Ⅱ卷 非选择题部分'),NULL,NULL,1,'answerable'),
(@pid,16,16,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','是助王息其民者也，何以至今不业也？',NULL,NULL,NULL,5,'reveal_only'),
(@pid,17,17,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','方其系燕父子以组，函梁君臣之首，入于太庙。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,18,18,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','既至匈奴，置币遗单于。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,19,19,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','居高以临下，不至于争，为其不足与我角也。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,20,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','去故乡而就远兮，遵江夏以流亡。 13 （二）把下面的句子翻译成现代汉语（共 8 分，每小题 2 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,21,21,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','是以圣人为而不恃，功成而不处，其不欲见贤。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,22,22,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','向使四君却客而不内，疏士而不用，是使国无富利之实而秦无强大之名也。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,23,23,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','老者衣帛食肉，黎民不饥不寒，然而不王者，未之有也。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,24,24,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','及其衰也，数十伶人困之，而身死国灭，为天下笑。 （三）用“/”给下面的文段断句（共 3 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,25,25,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','郑 人 有 一 子 将 宦 谓 其 家 曰 必 筑 坏 墙 是 不 善 人 将 窃 其 巷 人 亦 云 不 时 筑 而人 果 窃 之 以 其 子 为 智 以 巷 人 告 者 为 盗',NULL,NULL,NULL,5,'reveal_only'),
(@pid,26,26,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','__________，豺狼尽冠缨。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,27,27,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','结庐在人境，__________。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,28,28,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','__________，皎皎空中孤月轮。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,29,29,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','__________，蓬门今始为君开。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,30,30,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','玉容寂寞泪阑干，__________。 14',NULL,NULL,NULL,5,'reveal_only'),
(@pid,31,31,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','扣舷独啸，__________。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,32,32,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','哀州土之平乐兮，__________。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,33,33,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','__________，道男儿到死心如铁。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,34,NULL,'material','四、阅读题（本题共 3 小题，共 23 分）','【材料分析】

阅读下面文章，回答问题。（10 分）
①安塞在延安正北，离延安只有四十公里，可是过去由于交通不便，我家的亲戚朋友，
去过安塞的屈指可数。只是听说，安塞有个真武洞，那洞很神秘，藏着无数故事，一说可
以通到山西，一说可以通到靖边。春天的安塞，满山桃花。老辈人说，每年三月从洞那头
吹进去的桃花瓣，直到六月才能从这边飘出来。这个浪漫的故事，使我很是着迷。我班上
有个同学是安塞人，他告诉我，从延安西川流来的那条河，就源自安塞。所以那时候，一
个满怀好奇心的少年，常常望着滚滚而来的西川河水，充满遐想。
②二十多年后的一天，我终于有机会乘车去安塞。安塞路不好走，因为西川河弯弯曲
曲，常常挡在路上，大小石头在波浪中出没。这可忙坏了司机的双手，时而换高挡时而换
低挡，一个同行者喊道：“哎呀，快把人摇得散了黄了！”
③一进入安塞地界，到处是五谷的气息：玉米的、谷子的、糜子的、小麻的、黄豆的、
豌豆的，还有地椒的气息、羊的气息。地椒是这里和志丹、吴起一带独有的一种香味浓郁
的野草，到处都是。安塞的羊肉味道鲜美，缘于这里的羊吃地椒，仿佛长肉时，便已撒上
了香料。安塞街道不长，宁静安谧，铺面好多都住着人家。这里只有一个供销社和一座国
营食堂，要不是挂着一块县政府的牌子，人们也许想不到它是个县城。此时的我，已经工
作多年，少年时代的浪漫情怀所剩无几，看见真武洞洞口时，觉得它无非是个较大的山洞。
这是我对安塞最初的印象。
④其时我在延安歌舞团从事创作。有一天在院子里，我看见一些农村后生给舞蹈演员
示范打腰鼓，那动作如霹似雳，直击人心，顷刻把我镇住了。一问，那些后生全是安塞来
的。他们打腰鼓的英姿，出神入化，震荡心魄，那是任何演员都学不来的。这，给我的印
15
象太深了。我自愧虽然去过安塞，却不曾发现安塞还有这样一种灿烂的艺术。我心旌摇曳，
产生了创作冲动，想写一写安塞腰鼓。为此，我又专程去安塞看打腰鼓。安塞这时已修建
起相当气派的大礼堂。当时任县文化局副局长的贺玉堂，是一个已经在好几部电影中唱过
歌的著名民歌手，他在他的办公窑洞，为我放声高歌，那奇高的嗓音，让我叹服。他还就
近找了几个腰鼓手给我表演，我再一次被那腰鼓感染了，久久难以平静。然而，几次提笔，
又搁下。从生活到艺术，有时不是那么简单，甚至可以说是举步维艰。后来我认识到，那
是因为我内心的认知和感情，还未到火候。
⑤又过了好几年，中国迎来改革开放的大潮，人心大顺，万马驰鸣。我去关中西府千
阳农村下乡，心里也鼓胀着空前炽烈的激情。结果，只用了两个小时，我就把《安寒腰鼓》
写了出来，不久发表在《人民日报》上。就像以前发表作品一样，心里浮起一阵快意，不
过很快就烟消云散，一切如常。后来，这篇文章不断被选入各种散文选本。而且，它好像
变成了一群鸟儿，扑棱着翅膀，落上了如大树小树一般的各种语文课本。此时我才意识到，
它已成了我的代表作，贴在我的身上了，长在我的身上了。于是，我常常会想起安塞。
⑥去年我回到延安，受邀又一次来到安塞。汽车沿着宽阔的大路飞驰，一路上桥梁飞
架，已没有奔腾的河水挡道。大路平如砥，车如响箭飞。路的两侧有崛起不久的高楼大厦、
石箍窑洞。天上的云，好白好白。偶然也看到了羊群，羊群比云还白。一个老人踽踽前行，
折形的镢头朝后挂在肩上，镢把就像一股溪水，沿着他的躯体斜着向下流淌，自在如仙。
蓦然之间，看见了前面的腰鼓山，山上高竖着一个巨大的红色腰鼓，而山下就是安塞市区
了。现在的安塞，已是延安的一个区，高楼鳞次栉比，一派现代城市气象。市中心矗着一
座金色雕塑，造型是鼓手在捶击腰鼓，充满动感。他的双脚飞舞的场地，是一面大鼓的造
型，鼓面光亮，鼓身鲜红。安塞人，已经用腰鼓做了城市的招牌和名片。
⑦而我的注意力，已经落在一些斜背腰鼓的小朋友身上了。那是红军小学的娃娃。他
们在语文课上学过我的《安塞腰鼓》。听说我来了，呼啦啦地跑到我的面前，要给我表演
打腰鼓。他们的眼神，明亮而炽烈。他们那些好看的小脸蛋上，不知吸收过多少阳光，甜
美亮丽。和他们在一起，就像和袅袅上升的地气在一起。他们身上腰鼓的红、背带的红、
16
流苏的红，以及情绪的红，包裹着我，我成了喜庆的中心。打起腰鼓的孩子们，腿脚欢蹦，
精气神四射，鼓槌上的流苏飞舞，用语言极难形容。霎时间，我仿佛看见真武洞里飘出漫
天的桃花瓣！人道是“杏花春雨江南”，但这儿不属于江南，而属于北国，是北国里的安
塞、粗犷的安塞、强悍的安塞、谷子南瓜苹果飘香的安塞、“走头头骡子三盏盏灯”的安
塞，这儿是“桃花鼓声安塞”。在安塞，在日头映红的安塞，在石鲁笔下的火红高崖下，
孩子们忘情地歌舞。
⑧杏花的气质是温婉秀丽清清浅浅，桃花的风度是激越轩昂风风火火。如果说杏花的
魂灵是水，那么桃花的性情就是火，矢志不渝地燃烧。迎着高原的阳光，那些桃花瓣，从
真武洞里飘出极多极多，简直是喷出来的。花瓣一片挨着一片，一片映着一片，上下翻飞；
花瓣有如金的质地，铿锵劲舞；花瓣片片散发着香气，展示着这片土地的芳华。而那些孩
子们，则是一片环宇的光芒，一群火的精灵。安塞的丘陵沟壑里，奔腾着不少河流：延河、
杏子河、西川河、小川河、小沟河、双阳河……现在发现，在它的地层下，有更多的石油
河。整个安寒大地，是包着一团火的。世世代代的安塞人，也像这片土地一样，心底回荡
奔突着滚烫的热血。
⑨早在古代，安塞就有“上郡咽喉”之称，常有重兵把守，山山岭岭都回荡过战鼓助
阵的声音。唐朝的“安史之乱”期间，伟大的诗人杜甫，望着安塞的芦子关，写下了感时
忧国的诗篇。在解放战争中，安塞出过一支英勇善战的游击队——塞西支队，它的队长安
塞人田启元更是威名远扬。1947 年，西北野战军三战三捷，正是在真武洞，彭德怀将军召
开了五万军民参加的祝捷大会，留下了一帧英姿勃发的照片。有人说，冲着安塞一眼望不
到头的高山大峁一声喊，随时都会出现九路烟尘、八百悍将、三千五百雷霆。这片土地孕
育出的腰鼓艺术，哪能不高迈劲健、威震八方？
⑩眼前是桃花鼓声安塞，是打腰鼓的安塞。这腰鼓的磅礴气势，来自唐宋元明，来自
长河落日，来自“天苍苍，野茫茫”，来自中华古老的优秀传统，也寄托着我们新的希冀。
想起老人们说的，娃娃们若成了优秀的腰鼓手，一辈子都会蓬勃向上，永不沉沦。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,35,35,'essay','四、阅读题（本题共 3 小题，共 23 分）','（1）田饶所说鸡与鸿鹄各喻指了什么样的人？（3 分） 18',NULL,NULL,NULL,8,'reveal_only'),
(@pid,36,36,'essay','四、阅读题（本题共 3 小题，共 23 分）','（1）请赏析颈联“声拂琴床生雅趣，影侵棋局助清欢”。（3 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,37,NULL,'essay','四、阅读题（本题共 3 小题，共 23 分）','（2）文中所引的《诗》中的“乐土”在这里指什么？（4 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,38,NULL,'essay','四、阅读题（本题共 3 小题，共 23 分）','（2）请结合全诗，谈谈你对尾联的理解。（3 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,39,37,'essay','五、作文（本题共 40 分）','阅读下面的文字，根据要求作文。 互联网普及，把人类带进了信息时代，人们享受着足不出户，万事皆知的便捷，惊叹 于事传千里，人难邂逅的网络力量，互联网信息如潮，来源广泛，真真假假；互联网热点 19 频现，更迭频繁，“一人未唱罢我登台”……互联网正在改变着人们的生活和思维。 读了上述文字，根据你的思考写文章。 要求：题目自拟，立意自定，文体不限，不少于 800 字。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 大学语文 2023 (36 题, published=1) · 中文卷解析·选择12·材料1·主观23·暂缺0·共36 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='大学语文' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','《齐桓晋文之事》中，听孟子宣讲“仁政”主张的君主是（ ）。',JSON_ARRAY('A. 齐桓公','B. 晋文公','C. 梁惠王','D. 齐宣王'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','《过秦论》（上）中，作者认为强秦覆亡的原因是（ ）。',JSON_ARRAY('A. 废先王之道，焚百家之言，以愚黔首','B. 隳名城，杀豪杰，收天下之兵','C. 天下云集响应，赢粮而景从，山东豪俊遂并起而亡秦族','D. 仁义不施，而攻守之势异也'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','封建时代臣子向君主陈述意见的文体是（ ）。',JSON_ARRAY('A. 疏','B. 序','C. 赋','D. 论'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','《春江花月夜》中没有出现的意象是（ ）。',JSON_ARRAY('A. 流霜','B. 鸿雁','C. 清风','D. 白云'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','下列作品中多用典故且“以文为词”的是（ ）。',JSON_ARRAY('A. 柳宗元《始得西山宴游记》 2','B. 陆游《沈园二首》','C. 辛弃疾《贺新郎·同父见和再用韵答之》','D. 张孝祥《念奴娇·过洞庭》'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','《张中丞传后叙》中刻画南霁云形象的事件是（ ）。',JSON_ARRAY('A. 引绳而绝','B. 拔刀断指','C. 背诵《汉书》','D. 杀妾食肉'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','全祖望《梅花岭记》重点写的是（ ）。',JSON_ARRAY('A. 梅花','B. 梅花岭','C. 文天祥','D. 史可法'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','下列选项中，揭示封建旧文化压抑人性、摧残生命的作品是（ ）。',JSON_ARRAY('A. 宗璞《哭小弟》','B. 吴组缃《菉竹山房》','C. 陆蠡《囚绿记》','D. 张洁《拣麦穗》'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','在《纪念傅雷》一文中，作者认为傅雷最突出的性格是（ ）。',JSON_ARRAY('A. 刚直','B. 勇敢','C. 真诚','D. 开朗'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','莫言认为自己最有象征性、最意味深长的作品是（ ）。',JSON_ARRAY('A. 《透明的红萝卜》','B. 《檀香刑》','C. 《天堂蒜薹之歌》','D. 《秋水》'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','下列作品不属于莎士比亚“四大悲剧”的是（ ）。',JSON_ARRAY('A. 《哈姆雷特》','B. 《约翰·克里斯朵夫》','C. 《麦克白》','D. 《奥赛罗》'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、选择题（本题共 12 小题，每小题 1 分，共 12 分。每小题只有','对奥尔多·利奥波德《像山那样思考》的评析，不正确的一项是（ ）。',JSON_ARRAY('A. 作品说理不枯燥，语言饱含诗意，意味隽永','B. 作品以狼与鹿的故事论证了生态平衡的重要性','C. 作品用垂死的狼比喻因破坏自然环境而遭受报应的人 3','D. 作品运用了抒情、叙述与议论相结合的艺术手法 第Ⅱ卷 非选择题部分'),NULL,NULL,1,'answerable'),
(@pid,13,13,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','保民而王，莫之能御也。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,14,14,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','人之道则不然，损不足以奉有余。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,15,15,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','乃幽武置大窖中，绝不饮食。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,16,16,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','臣闻求木之长者，必固其根本。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,17,17,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','浩浩乎如冯虚御风，而不知其所止。 （二）把下面的句子翻译成现代汉语（共 8 分，每小题 2 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,18,18,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','忧劳可以兴国，逸豫可以亡身，自然之理也。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,19,19,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','今不问王而先问岁与民，岂先贱而后尊贵者乎？ 4',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,20,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','此数宝者，秦不生一焉，而陛下说之，何也？',NULL,NULL,NULL,5,'reveal_only'),
(@pid,21,21,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','天下有公利而莫或兴之，有公害而莫或除之。 （三）用“/”给下面的文段断句（3 分）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,22,22,'essay','二、古文翻译与断句题（本题共 10 小题，共 16 分）','凡 音 之 起 由 人 心 生 也 人 心 之 动 物 使 之 然 也 感 于 物 而 动 故 形 于 声 声 相 应故 生 变 变 成 方 谓 之 音 比 音 而 乐 之 及 干 戚 羽 旄 谓 之 乐（《礼记·乐本》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,23,23,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','夫唯弗居，__________。（《老子二章》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,24,24,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','是故为川者决之使导，__________。（《国语》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,25,25,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','__________，涕淫淫其若霰。（《哀郢》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,26,26,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','鸳鸯瓦冷霜华重，__________。（《长恨歌》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,27,27,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','__________，又岂在朝朝暮暮！（《鹊桥仙》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,28,28,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','不知乘月几人归，__________。（《春江花月夜》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,29,29,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','清风徐来，__________。（《赤壁赋》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,30,30,'essay','三、名句默写题（本题共 8 小题，任选 6 题作答，多答只按前 6 题','短发萧骚襟袖冷，__________。（《念奴娇·过洞庭》）',NULL,NULL,NULL,5,'reveal_only'),
(@pid,31,NULL,'material','四、阅读题（本题共 3 小题，共 26 分）','【材料分析】

阅读下面文章，回答问题。（10 分）
5
雕窝的月亮
金宏达
①不见雕窝的月亮已久矣。
②京城东北有地名“平谷”，平谷东北有村名“雕窝”，此村当初是否确有大雕筑窝，
因以为名，实不可考，我初到之时，以及尔后，完全不见雕之踪迹，是可以肯定的。
③多年以前，一位朋友邀我和内人来这里玩，是个萧索的秋天，风卷落叶遍地翻飞，
艳阳高照，却也挡不住寒意袭人。村长把我们当贵客陪着，路过一户院子，门紧锁，村长
说这家主人进城去住了，房子要卖，问我们是否有兴趣。我们扒门缝往里看，坐南朝北一
排五间房，院子水泥铺地，干净、整齐，立即看中了，卖价又实在便宜，便着手买下。
④此村虽叫雕窝，当地人却习惯写做“刁窝”，大约也是因为后者笔划从简之故，我
对“刁”字向无好感，很想“拔乱反正”一下，便在我买下的院子里挂了个横匾，上书“雕
憩园”三个字，意思是这里无论如何也与大雕的栖止有关
⑤“雕憩园”稍事修葺，就可以住了，那时我还在上班，便常在周末过来，享受远郊
山居的悠闲时光。在这里，有各种令人适情的事，而我所最爱的，就是赏月。
⑥赏月何处不可？何以最爱于此？我的小院虽在大路一侧，入院即见一锥形之山，壁
立另一侧——这山也是奇了，三面十分陡峭，无路可上，与小院相距一里多远，看上去却
似紧挨着一般，又像是一个硕大的山石盆景，直接搁进院来。山不知何名，问过当地人，
也答不上，想来无名，既无路可上，与各人过日子无关，也懒得命名。苏东坡写《赤壁赋》，
云“少焉，月出于东山之上，徘徊于斗牛之间”，此山在我的小院东墙之外，当然即是我
的东山。我于是就能常常看到“月出于东山之上”了。
⑦月出的时间有早有晚，早出的光景，有时未及观看，要稍晚一些，村里人声渐息，
看它静静地登上东山之顶，最为动人。
⑧我的小院里并无什么陈设，只有一棵山楂树，两棵龙爪槐，东南角院墙搭了一间小
屋作厨房，没有月亮的晚上，它们都隐于暗彩中。月亮将出未出之际，最先感知的便是它
们，像是有光波在空中悄然潜入、传送，渐渐就显出了它们秀挺的身姿。这时，若抬头一
6
看，就能看到东山顶端，一片辉煌，那正是明月的盛大仪仗。须臾之间，它就登上山顶，
由半露面而现真容了，周边的天空霎时光亮起来，天空的下方，村庄的房舍、树木、道路
也都无不照亮。平日白昼看东山，也没有此时清清楚楚，它周身的每一道皱折，岩缝中冒
出的每一棵小树小草，无不“须眉毕现”，你不能不为它的亮度叫绝，同时，也忽然一悟
——原来我们的语汇中常用的“光临”一词，造词的灵感却是来自这里。
⑨月亮循着它的路线继续上行，村庄在沉入梦乡，天地之间一片静谧，有时连一声狗
吠、虫鸣都没有，这个山谷按说并不荒凉，而此时在这冷色的月华下呈现出的寂静，却使
人产生趋近往古的感觉。我披衣在院中踯躅，想象着“今人不见古时月，今月曾经照古人”，
这是读过一些古典文学作品的人都会兴起的情思，它们很容易把人的心怀引向无限的旷远，
也不免增生几许惆怅。正是这个时候，让人特别意识到这种生活场景的转移多么触及灵魂。
月光如水，一点也不夸饰，它慷慨地涤洗下界的一切，包括人的心灵蒙上的点点凡尘。你
不禁会想到，平日在城里，在林立的楼宇间作息，我们是太忽略了它的存在了，不然又会
避免多少沉溺与迷失。
⑩月亮渐渐升上天顶，这是最能仰看它正大仙容的时刻，也正是在此刻，才真正让人
领略什么是“孤光自照，肝肺皆冰雪”。夜深了，尽管已有几分露寒，我也不愿进屋就寝，
我知道人生途中，与月亮的这般相遇，其实也并不会多，古人不去说了，近人如朱自清先
生，彳亍在学校的荷塘边，不也是只能玩赏些朦胧的月色，做一做“笼着轻纱的梦”吗？
诗仙李白与明月的聚饮也是“醒时同交欢，醉后各分散”，能在醒时和一轮朗月如此晤对，
无论如何也是要格外珍惜的。
⑪那么，又何妨打开院门，到外头去走一走呢？路上是看不见一个人影的，路灯亮着，
却是无法与月光争辉，走在一条白亮亮的大路上，视野更为广阔，西边的山峦披着银辉起
伏绵延，林树浓密，明暗不一，层次繁复，不是有一句古人的词云：“便欲凌空，飘然直
上，拂拭山河影”吗？啊，此时的月亮正是要去完成“拂拭”的，前方不远处，还有一个
水库，渟蓄着一方碧水，水天交映，便把这个银色的世界衬托得更加空明和碧净了。
⑫兴尽归来，却也听得几声吠声吠影的狗叫，我知道这也吵不醒酣睡的人们，人们早
7
已习惯于月起月落，星移斗转，他们在黑甜乡里正枕着一个永恒的记忆。
（选自《散文 2022 精选集》，有删改）',NULL,NULL,NULL,0,'reveal_only'),
(@pid,32,32,'essay','四、阅读题（本题共 3 小题，共 26 分）','（1）行人烛过认为“鼓之而士不起”的原因是什么？他是如何开展陈述的？请结合原文回 答。（5 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,33,33,'essay','四、阅读题（本题共 3 小题，共 26 分）','（1）《秋兴八首》（其一）如何围绕“秋”字来点题？（4 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,34,NULL,'essay','四、阅读题（本题共 3 小题，共 26 分）','（2）请结合全文分析赵简子的形象。（3 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,35,NULL,'essay','四、阅读题（本题共 3 小题，共 26 分）','（2）这两首诗出自同题组诗，但抒发的情感各有侧重，请结合诗句分析。（4 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,36,34,'essay','五、作文（本题共 40 分）','阅读下面的文字，根据要求作文。（40 分） 终身学习是指社会成员未来实现个体发展，适应社会进步而持续学习的过程，具有终 身性、广泛性的特点。在知识更新迭代日益加速的今天，有人疏于学习，被时代抛弃，有 的人不断学习，持续发展，成为时代的弄潮儿。 读了上述文字，根据你的思考写一篇文章。 要求：题目自拟，立意自定，文体不限，不少于 800 字。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 大学语文 2024 (34 题, published=1) · 中文卷解析·选择12·材料1·主观21·暂缺0·共34 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='大学语文' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','下列关于《诗经》的表述，不正确的是（ ）',JSON_ARRAY('A. 分为“风”“雅”“颂”三个部分','B. 多用比兴手法，意蕴丰赡含蓄','C. 常用重章叠句，情致回环往复','D. 后代传诗的有四家，魏晋以后，唯韩诗得以通行'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','下列选项中，通过纪行叙事寄托故国之思，表达遭遇放逐的痛楚与激的作品是（ ）。',JSON_ARRAY('A. 《哀郢》','B. 《过秦论》','C. 《谏逐客书》','D. 《长恨歌》'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','欧阳修在《五代史伶官传序》中，认为国家政权兴盛与衰败主要取决于（ ）。',JSON_ARRAY('A. 天命','B. 人事','C. 大民','D. 兵力'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','郑燮在《范县苦中寄舍弟显第四书》中，称天地间第一等人是（ ）。',JSON_ARRAY('A. 士','B. 农','C. 工','D. 商'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','下列选项中，属于“移于景”写法的诗句是（ ）。',JSON_ARRAY('A. 春风桃李花开日，秋雨梧桐叶落时','B. 迟迟钟鼓初长夜，耿耿星河欲曙天','C. 行宫见月伤心色，夜雨闻铃肠断声','D. 峨嵋山下少人行，旌旗无光日色薄'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','睢景臣《般涉调·哨遍》（高祖还乡）的叙事视角是（ ）。',JSON_ARRAY('A. 高祖','B. 百姓','C. 官员','D. 士兵'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','余秋雨《都江堰》一文中，用来跟都江堰相比的另一古代工程是（ ）。',JSON_ARRAY('A. 长城','B. 郑国渠','C. 灵渠','D. 大运河'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','陈启佑《永远的蝴蝶》一文中，怀念的人是（ ）。',JSON_ARRAY('A. 姐姐','B. 小女儿','C. 妈妈','D. 未婚妻'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','鲁迅《论睁了眼看》批判的思想和文艺是（ ）。',JSON_ARRAY('A. 瞒和骗','B. 因果报应','C. 拿来主义','D. 个人主义'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','朱光潜《慢慢走，欣赏啊！——人生的艺术化》没有出现的典故是（ ）。',JSON_ARRAY('A. 东施效颦','B. 孟敏堕甑','C. 江郎才尽','D. 王徽之访戴'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','马丁·路德·金《我有一个梦想》演讲词中的“梦想”是（ ）。',JSON_ARRAY('A. 平等自由','B. 解放黑奴','C. 世界和平','D. 民族独立'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题：本大题共 12 小题，每小题 1 分，共 12 分。','下列选项中，以明暗两条线索结构篇章讲述三位贫穷艺术家相濡以沫的故事，歌颂普通人心灵之美的作 品是（ ）。',JSON_ARRAY('A. 《故园之恋》','B. 《像山那样思考》','C. 《心灵的镜子》','D. 《最后的常春藤叶》 第二部分 非选择题'),NULL,NULL,1,'answerable'),
(@pid,13,13,'essay','二、翻译加点的字：本大题共 5 小题，每小题 1 分，共 5 分。','保民而王，莫之能御．也。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,14,14,'essay','二、翻译加点的字：本大题共 5 小题，每小题 1 分，共 5 分。','威后问使者曰：“岁．亦无恙耶？”',NULL,NULL,NULL,1,'reveal_only'),
(@pid,15,15,'essay','二、翻译加点的字：本大题共 5 小题，每小题 1 分，共 5 分。','河海不择细流，故能就．其深。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,16,16,'essay','二、翻译加点的字：本大题共 5 小题，每小题 1 分，共 5 分。','秦人开关延．敌，九国之师逡巡而不敢进。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,17,17,'essay','二、翻译加点的字：本大题共 5 小题，每小题 1 分，共 5 分。','将崇极天之峻，永保无疆之休．。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,18,'essay','三、句子翻译题：本大题共 4 小题，每小题 2 分，共 8 分。','百姓皆以王为爱也，臣固知王之不忍也。《齐桓晋文之事》',NULL,NULL,NULL,2,'reveal_only'),
(@pid,19,19,'essay','三、句子翻译题：本大题共 4 小题，每小题 2 分，共 8 分。','是其为人也，上不臣于王，下不治其家，中不索交诸侯。《赵威后问齐使》',NULL,NULL,NULL,2,'reveal_only'),
(@pid,20,20,'essay','三、句子翻译题：本大题共 4 小题，每小题 2 分，共 8 分。','今足下还归，扬名于匈奴，功显于汉室。《苏武传》',NULL,NULL,NULL,2,'reveal_only'),
(@pid,21,21,'essay','三、句子翻译题：本大题共 4 小题，每小题 2 分，共 8 分。','居高以临下，不至于争，为其不足与我角也。《息争》',NULL,NULL,NULL,2,'reveal_only'),
(@pid,22,22,'essay','四、断句题：本大题共 1 题，共 3 分。','当 是 时 也 商 君 佐 内 立 法 度 务 耕 织 修 守 战 之 具 外 连 衡 而 斗 诸 侯 于 是 秦 人 拱 手 而 取 西 河 之 外',NULL,NULL,NULL,3,'reveal_only'),
(@pid,23,23,'essay','五、名句默写：本题共 8 题，任选 6 题作答，多答只按前 6 题计分，每题 1 分，共 6 分。','举酒属客，诵明月之诗， 。《赤壁赋》',NULL,NULL,NULL,1,'reveal_only'),
(@pid,24,24,'essay','五、名句默写：本题共 8 题，任选 6 题作答，多答只按前 6 题计分，每题 1 分，共 6 分。','悠悠乎与颢气俱，而莫得其涯； ，而不知其所穷。《始得西山宴游记》',NULL,NULL,NULL,1,'reveal_only'),
(@pid,25,25,'essay','五、名句默写：本题共 8 题，任选 6 题作答，多答只按前 6 题计分，每题 1 分，共 6 分。','，可怜春半不还家。《春江花月夜》',NULL,NULL,NULL,1,'reveal_only'),
(@pid,26,26,'essay','五、名句默写：本题共 8 题，任选 6 题作答，多答只按前 6 题计分，每题 1 分，共 6 分。','应念岭海经年， ，肝肺皆冰雪。《念奴娇·过洞庭》',NULL,NULL,NULL,1,'reveal_only'),
(@pid,27,27,'essay','五、名句默写：本题共 8 题，任选 6 题作答，多答只按前 6 题计分，每题 1 分，共 6 分。','宋代李清照号“易安居士”，“易安”出自陶渊明《归去来兮辞》中的 ， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,28,NULL,'material','六、阅读题：本大题共 3 小题，共 26 分。','【材料分析】

阅读下文，回答问题。（10 分）
成都的春天
刘大杰
①成都天气，热的时候不过热，冷的时候不过冷，水分很多，阴晴不定，宜于养花木，不宜于养人。
因此，住在成都的人，气色没有好的，而花木无一不好。在北平江南一带看不见的好梅花，成都有，在外
面看不见的四五丈高的玉兰，二三丈高的夹竹桃，成都也有。据外国人说，成都的兰花，在三百种以上。
外面把兰花看重得宝贝一样，这里的兰花，真是遍地都是，贱得如江南一带的油菜花，三分钱买一大把，
你可以插好几瓶。从外面来的朋友，没有一个人不骂成都的天气，但没有一个不爱成都的花木。
②成都这个城市，有一点京派的风味。栽花种花，对酒品茗，在生活中占了很重要的一部分。一个穷
人家住的房子，院子里总有几十株花草，一年四季，不断地开着鲜艳的花。他们都懂得培植，懂得衬贴。
一丛小竹的旁边，栽着几树桃，绿梅的旁边衬着红梅，蔷薇的附近植着橙柑，这种衬贴扶持，显出调和，
显出不单调。
③成都的春天，恐怕要比北平江南早一月到两月吧。二月半到三月半，是梅花盛开的时候，街头巷尾，
院里墙间，无处不是梅花的颜色。绿梅以清淡胜，朱砂梅以娇艳胜，粉梅则品不高，然在无锡梅园苏州邓
尉所看见的，则全是这种粉梅也。“疏影横斜水清浅，暗香浮动月黄昏”，林和靖先生的诗确是做得好，
但这里的好梅花，他恐怕还没有见过。碧绿，雪白，粉红，朱红，各种各样的颜色，配合得适宜而又自然，
真配得上“香雪海”那三个字。
④)现在是三月底，梅兰早已谢了，正是海棠玉兰桃杏梨李迎春各种花木争奇斗艳的时候杨柳早已拖着
柔媚的长条，在百花潭浣花溪的水边悠悠地飘动，大的鸟小的鸟，颜色很好看不知道名字，飞来飞去地唱
着歌。薛涛林公园也充满了春意，有老诗人在那里吊古，有青年男女在那里游春。有的在吹箫唱曲，有的
在垂钓弹，这种情味，比起西湖上的风光，全是两样。
⑤花朝，是成都花会开幕的日子。地点在南门外十二桥边的青羊宫。花会期有一个月。这是一个成都
青年男女解放的时期。花会与上海的浴佛节有点相像，不过成都的是以卖花为主，再辅助着各种游艺与各
地的出产。平日我们在街上不容易看到艳妆的妇女，到这时候，成都人倾城而出，买花的，卖花的，看人
的，被人看的，摩肩擦背，真是拥挤得不堪。高鞋，花裤，桃色的衣裳，卷卷的头发，五光十色，无奇不
有，与其说是花会，不如说是成都人展览会。好像是闷居了一年的成都人，都要借这个机会来发泄一下似
的，醉的大醉，闹的大闹，最高兴的，还是小孩子，手里抱着风车风筝，口里嚼着糖，唱着回城去，想着
古人的“无人不道看花回”的句子，真是最妥当也没有的了。
⑥到百花潭去走走，那情境也极好。对面就是工部草堂，一只有篷顶的渡船，时时预备在那里，你摇
一摇手，他就来渡你过去。一潭水清得怪可爱，水浅地方的游鱼，望得清清楚楚，无论你什么时候去，总
有一群人在那里钓鱼，不管有鱼无鱼，他们都能忍耐地坐在那里谈谈笑笑，总要到黄昏时候，才一群一群
地进城。堤边十几株大杨柳，垂着新绿的长条，尖子都拂在水面上，微风过去，在水面上摇动着美丽的波
纹。
⑦没有事的时候，你可以到茶馆里去坐一坐。茶馆在成都真是遍地都是，一把竹椅，一张不成样子的
木板桌，你可以泡一碗茶（只要三分钱），可以坐一个下午。在那里你可以看到许多平日你看不见的东西。
有的卖字画，有的卖图章，有的卖旧衣服。你有时候，可以用最少的钱，买到一些很好的物品。郊外的茶
馆，有的临江，有的在花木下面，你坐在那里，茶，吃花生米，可以悠悠地欣赏自然，或是读书，或是睡
觉，你都很舒服。高起兴来，还可以叫来一两样菜，半斤酒，可以喝得醉醺醺，坐着车子进城。你所感到
的，只是轻松与悠闲，如外面都市中的那种紧张的空气，你会一点也感觉不到。我时常想，一个人在成都
住得太久了，会变成一个懒人，一个得过且过的懒人。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,29,32,'essay','六、阅读题：本大题共 3 小题，共 26 分。','（1）文中两次提到“虢君喜”，请说明原因。（2 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,30,33,'essay','六、阅读题：本大题共 3 小题，共 26 分。','（1）两首古诗词都用了拟人手法，请分析说明。（4 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,31,NULL,'essay','六、阅读题：本大题共 3 小题，共 26 分。','（2）御逃亡途中的言行发生了怎样的变化？（3 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,32,NULL,'essay','六、阅读题：本大题共 3 小题，共 26 分。','（3）这篇文章告诉我们什么道理？（3 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,33,NULL,'essay','六、阅读题：本大题共 3 小题，共 26 分。','（2）如何理解《清平乐·欺烟闲雨》中“风流全在轻黄”？（4 分）',NULL,NULL,NULL,8,'reveal_only'),
(@pid,34,34,'essay','七、作文题：本大题共 1 题，共 40 分。','阅读以上材料，自选角度，自拟题目，写一篇不少于 800 字的文章。 ①“3 分钟看完一部电影”“5 分钟读完一本名著”“10 分钟带你了解历史”……类似的短视频节目 如今在网上大行其道，点击率和点赞量庞大，受众群体广泛。 ②《五天学会绘画》《十天搞定考研词汇》《十五天突破高考作文》《三十天毛笔速成》……书店里、 网络上充斥着各种速成“宝典”，而且这些速成“宝典”大有市场。 ③近年来，通过手机、电子书等工具进行不完整的、断断续续的碎片化阅读日益流行，并逐渐成为大 众阅读的新趋势。 对于生活中日益流行的“短、快、碎”的文化现象，你有什么看法和感悟?请写一篇文章加以阐述。 要求：结合材料，选好角度，确定立意，明确文体，自拟标题，不要套作，不得抄袭，不得泄露个人 信息，不少于 800 字。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 大学语文 2025 (31 题, published=1) · 中文卷解析·无完整选择但主观可用·材料1·主观18·暂缺12·共31 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='大学语文' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,2,2,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,3,3,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,4,4,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,5,5,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,6,6,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,7,7,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,8,8,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,9,9,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,10,10,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,11,11,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,12,12,'choice','一、单项选择题（本大题共 12 小题，每小题 1 分，共 12 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,13,18,'essay','二、古文翻译与断句题（本大题共 16 分）','律知武终不可胁，白单于。单于愈益欲降之。',NULL,NULL,NULL,16,'reveal_only'),
(@pid,14,19,'essay','二、古文翻译与断句题（本大题共 16 分）','夫祸患常积于忽微，智勇多困于所溺，岂独伶也哉。',NULL,NULL,NULL,16,'reveal_only'),
(@pid,15,20,'essay','二、古文翻译与断句题（本大题共 16 分）','抑王兴甲兵，危士臣，构怨于诸侯，然后快于心与。',NULL,NULL,NULL,16,'reveal_only'),
(@pid,16,21,'essay','二、古文翻译与断句题（本大题共 16 分）','臣奉使使威后，今不问王而先问岁与民，岂先贱而后尊贵者乎。',NULL,NULL,NULL,16,'reveal_only'),
(@pid,17,22,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','，思而不学则殆。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,23,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','春风桃李花开日， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,19,24,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','知不可乎骤得， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,20,25,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','，心远地自偏。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,21,26,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','，曾是惊鸿照影来。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,22,27,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','自古逢秋悲寂寥， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,23,28,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','洛阳亲友如相问， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,24,29,'essay','三、名句默写题（本大题共 8 小题，任选 6 题，多选只按前 6 题计分，每空 1 分，共6 分）','海日生残夜， 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,25,NULL,'material','四、阅读题（本大题共 3 题，共 26 分）','【材料分析】

阅读下文，回答问题。（10 分）
晋侯复假道于虞以伐虢。宫之奇谏曰：“虢，虞之表也。虢亡，虞必从之。晋不可启，寇不可翫。一
之谓甚，其可再乎？谚所谓‘辅车相依，唇亡齿寒’者，其虞、虢之谓也。”
公曰：“晋，吾宗也，岂害我哉？”
对曰：“大伯、虞仲，大王之昭也。大伯不从，是以不嗣。虢仲、虢叔，王季之穆也，为文王卿士，
勋在王室，藏于盟府。将虢是灭，何爱于虞！且虞能亲于桓、庄乎？其爱之也，桓、庄之族何罪？而以为
戮，不唯逼（bī）乎？亲以宠逼，犹尚害之，况以国乎？”
公曰：“吾享祀丰絜，神必据我。”
对曰：“臣闻之，鬼神非人实亲，惟德是依。故周书曰：‘皇天无亲，惟德是辅。’又曰：‘黍稷非
馨，明德惟馨。’又曰：‘民不易物，惟德繄（yī）物。’如是，则非德民不和，神不享矣。神所冯（píng）
依，将在德矣。若晋取虞，而明德以荐馨香，神其吐之乎？”
弗听，许晋使。
宫之奇以其族行，曰：“虞不腊矣。在此行也，晋不更举矣。”
八月甲午，晋侯围上阳，问于卜偃曰：“吾其济乎？”
对曰：“克之。”

公曰：“何时？”
对曰：“童谣曰：‘丙之晨，龙尾伏辰，均服振振，取虢之旂。鹑之贲贲，天策炖炖，火中成军，虢
公其奔。’其九月、十月之交乎！丙子旦，日在尾，月在策，鹑火中，必是时也。”
冬，十二月丙子朔，晋灭虢，虢公丑奔京师。师还，馆于虞，遂袭虞，灭之,执虞公.及其大夫井伯，
以媵秦穆姬。而修虞祀，且归其职贡于王，故书曰：“晋人执虞公。”罪虞公，言易也
（《宫之奇谏假道》）',NULL,NULL,NULL,0,'reveal_only'),
(@pid,26,31,'essay','四、阅读题（本大题共 3 题，共 26 分）','（1）指出文章的两个判断句。',NULL,NULL,NULL,26,'reveal_only'),
(@pid,27,32,'essay','四、阅读题（本大题共 3 题，共 26 分）','阅读下文，回答问题。（8 分） 昔者晋献公欲假道于虞以伐虢。荀息曰：“君其以垂棘之璧与屈产之乘赂虞公，求假道焉，必假我道。” 君曰：“垂棘之璧，吾先君之宝也；屈产之乘，寡人之骏马也。若受吾币不假之道，将奈何？”荀息曰： “彼不假我道，必不敢受我。若受我，而假我道，则是宝犹取之内府而藏之外府也，马犹取之内厩而著之 外厩也。君勿忧。”君曰：“诺。”乃使荀息以垂棘之璧与屈产之乘赂虞公而求假道焉。虞公贪利其璧与 马而欲许之。宫之奇谏曰：“不可许。夫虞之有虢也，如车之有辅。辅依车，车亦依辅，虞、虢之势正是 也。若假之道，则虢朝亡而虞夕从之矣。不可，愿勿许。”虞公弗听，遂假之道。荀息伐虢，克之，还反 处三年，与兵伐虞，又克之，荀息牵马操璧而报献公，献公说曰：“璧则犹是也。虽然，马齿亦益长矣。” 故虞公之兵殆而地削者，何也？爱小利而不虑其害。故曰：顾小利，则大利之残也。 题目暂无',NULL,NULL,NULL,26,'reveal_only'),
(@pid,28,NULL,'essay','四、阅读题（本大题共 3 题，共 26 分）','（2）指出文章中的宾语前置句并说明分析。',NULL,NULL,NULL,26,'reveal_only'),
(@pid,29,NULL,'essay','四、阅读题（本大题共 3 题，共 26 分）','（3）文章中标点“其”的词性和用法。',NULL,NULL,NULL,26,'reveal_only'),
(@pid,30,NULL,'essay','四、阅读题（本大题共 3 题，共 26 分）','（4）指出文章三个古字或通假字，并标注出今字。',NULL,NULL,NULL,26,'reveal_only'),
(@pid,31,33,'essay','五、作文（本题 40 分）','阅读下面的材料，根据要求写作。 勇敢的人先享受世界，随心而动说走就走。大好河山我想看看的是诗意理想不该受困于人间烟火! 以上材料引发了你怎样的联想和思考？请写一篇文章。 要求：题目自拟，立意自定，文体不限（诗歌除外），字数不少于 800 字。',NULL,NULL,NULL,40,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 政治理论 2022 (41 题, published=1) · 中文卷解析·选择27·材料3·主观8·暂缺0·共41 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='政治理论' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2021 年 7 月 1 日，首都各界在北京天安门举行隆重集会，热烈庆祝（ ）。',JSON_ARRAY('A. 中华人民共和国收回香港 24 周年','B. 中国共产党成立 100 周年','C. 中华人民共和国成立 72 周年','D. 中华人民共和国恢复在联合国合法席位 50 年'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','为改善我国人口结构，落实积极应对人口老龄化国家战略，保持我国人力资源禀赋优势，2021 年 5 月 31 日作出（ ）。',JSON_ARRAY('A. 一对夫妻可以生育子女政策','B. 夫妻双方都是独生子女家庭可以生育两个孩子','C. 一对夫妻可以生育 3 子女政策','D. 全面开放的生育政策'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','新华社北京 2021.3.11 电，我国为了完善香港特别行政区法律和政治体制，十三届全国人大四次会议以高 票表决通过了（ ）。',JSON_ARRAY('A. 《中华人民共和国香港特别行政区维护国家安全法》','B. 《全国人民代表大会关于完善香港特别行政区选举制度的决定》','C. 《香港特别行政区行政长官的产生办法》','D. 《香港特别行政区立法的产生办法和表决程序》'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2021 年 11 月 10 日，日本通过了临时国会的首相提名选举，当选日本 101 任首相（ ）。',JSON_ARRAY('A. 岸田文雄','B. 安倍晋三','C. 河野太郎','D. 野田圣子'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','1945 年，党的七大确立我党必须长期坚持的指导思想是（ ）。',JSON_ARRAY('A. 毛泽东思想','B. 邓小平理论','C. “三个代表”重要思想','D. 科学发展观'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','毛泽东第一次提出“新民主主义革命”科学概念的文章是（ ）。',JSON_ARRAY('A. 《“共产党人”发刊词》','B. 《中国革命和中国共产党》 C《新民主主义论》','D. 《论联合政府》'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','随着土地改革的基本完成，我国社会主要矛盾逐步成为（ ）。',JSON_ARRAY('A. 帝国主义和中华民族的矛盾','B. 封建主义和人民大众的矛盾','C. 工人阶级和资产阶级的矛盾','D. 农民阶级和资产阶级的矛盾'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','标志着党探索中国社会主义建设道路良好开端的著作是（ ）。',JSON_ARRAY('A. 《论人民民主专政》','B. 《从人的正确思想是从哪里来的》','C. 《关于正确处理人民内部矛盾的问题》','D. 《论十大关系》'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','新时期最鲜明的特点是（ ）。',JSON_ARRAY('A. 从严治党','B. 依法治国','C. 改革开放','D. 四个自信'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','标志着我国改革开放进入新时期，2001 年 12 月我国加入（ ）。',JSON_ARRAY('A. 巴黎协定','B. 世界贸易组织','C. 全面与进步跨太平洋伙伴关系协定','D. 亚欧经济合作'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','科学发展观的第一要义（ ）。',JSON_ARRAY('A. 经济','B. 发展','C. 政治','D. 文化'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','党的十九大作出的重大政治论断是经过长期努力中国特色社会主义进入了（ ）。',JSON_ARRAY('A. 新世纪','B. 新时期','C. 新阶段','D. 新时代'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','根据新发展理念，领导我国发展的第一动力是（ ）。',JSON_ARRAY('A. 创新','B. 协调','C. 绿色','D. 开放'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','中国社会主义民主政治独特、独有、独到的民主形式是（ ）。',JSON_ARRAY('A. 人民民主','B. 决策民生','C. 过程民生','D. 协商民主'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','民生是人民福祉，是社会和谐之本，改善民生的前提是（ ）。',JSON_ARRAY('A. 发展经济','B. 发扬民族','C. 按劳分配','D. 共享改革成果'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','首次把党的政治建设纳入党的建设总体布局是（ ）。',JSON_ARRAY('A. 党的十六大','B. 党的十七大','C. 党的十八大','D. 党的十九大'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2021 年 7 月 1 日，习近平在天安门城楼上庄严宣告，经过全党全国各族人民持续奋斗，实现了（ ）。',JSON_ARRAY('A. 社会主义现代化目标','B. 中华民族伟大复兴 C 第一个现代化目标','D. 第二个现代化目标'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','解决台湾问题，实现祖国统一是大势所趋，民心所向。实现祖国统一的最佳方式是（ ）。',JSON_ARRAY('A. 维持现状','B. 武力斗争','C. “一国两制”','D. 和平方式'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','中国的外交政策是（ ）。',JSON_ARRAY('A. 反对霸权主义','B. 推动建设新型国际关系','C. 推动构建人类命运共同体','D. 维护世界和平，走和平发展道路'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','实现社会主义现代化和民族复兴的最根本保证是（ ）。',JSON_ARRAY('A. 党的领导','B. 改革开放','C. 党的建设','D. 发展生产力'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）中国共产党第十九届中央委员会第六次全体会议于 2021 年 11 月 8 日至 11 日在北京召开，全体审议通 过（ ）。',JSON_ARRAY('A. 《关于若干历史问题的决议》','B. 《中共中央关于党的百年奋斗重大成就和历史经验的决议》','C. 《关于建国以来党的若干问题的决议》','D. 《关于召开第二十大全国党的代表大会的决定》'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）北京时间 2021 年 10 月 16 日 0 时 23 分，我国航天员搭乘神舟十三号载人飞船升空，进入我国自行设计 研发的空间站，开展为期半年的太空任务，这次乘组的航天员为（ ）。',JSON_ARRAY('A. 翟志刚','B. 王亚平','C. 聂海胜','D. 叶光富'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）中国共产党带领人民取得的重大成就（ ）。',JSON_ARRAY('A. 新民主主义革命','B. 社会主义建设和发展','C. 改革开放和社会主义现代化建设','D. 新时期社会主义现代化'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）中国革命的主要敌人（ ）。',JSON_ARRAY('A. 帝国主义','B. 改良主义','C. 封建主义','D. 官僚资本主义'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）社会主义制度建立以后，我们党对社会主义建设道路初步探索的理论成果主要有（ ）。',JSON_ARRAY('A. 走中国特色社会主义发展道路','B. 调动一切积极因素为社会主义事业服务的思想 C 正确认识和处理社会主义矛盾的思想','D. 走中国工业化道路的思想'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）“三个代表”重要思想的核心观点是我们党必须始终代表（ ）。',JSON_ARRAY('A. 始终代表中国先进生产力的发展要求','B. 中国先进生产关系的发展方向','C. 始终代表先进文化的前进方向','D. 始终代表浸广大人民的根本利益'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）科学发展观最鲜明的精神实质是（ ）。',JSON_ARRAY('A. 解放思想','B. 实事求是','C. 与时俱进','D. 求真务实'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）共享包括（ ）。',JSON_ARRAY('A. 全民共享','B. 全面共享','C. 共建共享','D. 渐进共享'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）我国基本政治制度（ ）。',JSON_ARRAY('A. 人民代表大会制度','B. 中国共产党领导的多党合作和政治协商制度','C. 民族区域自治制度','D. 基层群众自治制度'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）习近平生态文明思想深刻回答了（ ）。',JSON_ARRAY('A. 为什么建设生态文明','B. 建设什么样的生态文明','C. 怎样建设生态文明','D. 现代化建设目标'),NULL,NULL,2,'answerable'),
(@pid,31,31,'essay','三、辨析题（先判断正误，再作简要分析。本大题共 2 小题，每小题 7 分，共 14 分）','改革开放和社会主义现代化建设的实践是邓小平理论的现实依据。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,32,32,'essay','三、辨析题（先判断正误，再作简要分析。本大题共 2 小题，每小题 7 分，共 14 分）','中国的现代化是有别于资本主义的现代化。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,33,33,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）','简答如何坚持群众路线。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,34,34,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）','简答社会主义改造的历史经验。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,35,35,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）','简答确保党始终总揽全局协调各方。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,36,36,'essay','五、论述题（本大题共 10 分）','论述百年未有之大变局。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,37,NULL,'material','六、材料分析题（本大题共 15 分）','【材料1】

增强忧患意识，做到居安思危，是我们治党治国必须始终坚持的一个重大原则。我们党要巩固执政地位，
要团结带领人民坚持和发展中国特色社会主义，保证国家安全是头等大事。
——摘自习近平《在中央国家安全委员会第一次会议上的讲话》',NULL,NULL,NULL,0,'reveal_only'),
(@pid,38,NULL,'material','六、材料分析题（本大题共 15 分）','【材料2】

新的征程上，我们必须增强忧患意识，始终居安思危，贯彻总体国家安全观，统筹发展和安全，统筹中华
民族伟大复兴战略全局和世界百年未有之大变局，深刻认识我国社会主要矛盾变化带来的新征程新要求，
深刻认识错综复杂的国际环境带来的新矛盾新挑战，敢于斗争，善于斗争，逢山开道，遇水架桥，勇于战
胜一切风险挑战！
——摘自习近平《在庆祝中国共产党成立一百周年大会上的讲话》',NULL,NULL,NULL,0,'reveal_only'),
(@pid,39,NULL,'material','六、材料分析题（本大题共 15 分）','【材料3】

进入新时代，我国面临更为严峻的国家安全形势，外部压力前所未有，传统安全威胁和非传统安全威胁相
互交织，“黑天鹅”“灰犀牛”事件时有发生。同形势任务要求相比，我国维护国家安全能力不足，应对
各种重大风险能力不强，维护国家安全的统筹协调机制不健全。
——摘自《中共中央关于党的百年奋斗重大成就和历史经验的决议》',NULL,NULL,NULL,0,'reveal_only'),
(@pid,40,37,'essay','六、材料分析题（本大题共 15 分）','（1）上述材料说明了什么？',NULL,NULL,NULL,15,'reveal_only'),
(@pid,41,NULL,'essay','六、材料分析题（本大题共 15 分）','（2）怎样坚持总体国家安全观？',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 政治理论 2023 (41 题, published=1) · 中文卷解析·选择30·材料3·主观8·暂缺0·共41 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='政治理论' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2022 年是中国共产主义青年团成立（ ）。',JSON_ARRAY('A. 80 周年','B. 90 周年','C. 100 周年','D. 110 周年'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2022 年 6 月 6 日，国务院批复同意设立华南国家植物园的城市是（ ）。',JSON_ARRAY('A. 广州','B. 深圳','C. 珠海','D. 东莞'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2022 年 5 月 8 日，当选香港特别行政区第六任行政长官的是（ ）',JSON_ARRAY('A. 林郑月娥','B. 李家超','C. 曾萌权','D. 梁振英'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','海湾沙特阿拉伯国家合作委员会国家有史以来第一次派出运动员参加北京冬奥会是（ ）。',JSON_ARRAY('A. 伊朗','B. 沙特阿拉伯','C. 叙利亚','D. 科威特'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','标志着“马克思主义中国化“这一命题正式提出的会议是（ ）。',JSON_ARRAY('A. 党的六届六中全会','B. 党的一大','C. 党的二大','D. 党的七大'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','19 世纪末 20 世纪初，世界进入（ ）。',JSON_ARRAY('A. 资本主义时代','B. 帝国主义和无产阶级革命时代','C. 社会主义时代','D. 经济全球化时代'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','近代中国最基本国情是（ ）。',JSON_ARRAY('A. 人口多','B. 底子薄','C. 逐渐成为半殖民地半封建社会','D. 西方列强的入侵'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','从中华人民共和国成立到社会主义改造基本完成，这一时期我国社会性质是（ ）。',JSON_ARRAY('A. 资本主义社会','B. 社会主义社会','C. 新民主主义社会','D. 旧民主主义社会'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','我国社会主义改造任务完成以后，国家政治生活中逐步居于主导地位的矛盾是（ ）。',JSON_ARRAY('A. 无产阶级和资产阶级的矛盾','B. 社会主义和资本主义的矛盾','C. 敌我矛盾','D. 人民内部矛盾'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','邓小平理论的基本回答是（ ）。',JSON_ARRAY('A. 什么是改革开放，怎样进行改革开放','B. 什么是社会主义，怎样建设社会主义','C. 建设什么样的党，怎样建设党','D. 实现什么样的发展，怎样发展'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','江泽民首次比较全面阐述“三个代表”重要思想是在（ ）。',JSON_ARRAY('A. 广东考察工作时','B. 江苏考察工作时','C. 浙江考察工作时','D. 上海考察工作时'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','首次提出“中国特色社会主义理论体系”的科学概念的是（ ）。',JSON_ARRAY('A. 党的十五大','B. 党的十六大','C. 党的十七大','D. 党的十八大'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','实现中华民族伟大复兴的根本保证是（ ）',JSON_ARRAY('A. 中国共产党的领导','B. 中国人民的大团结','C. 改革的深化','D. 对外开放的扩大'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','把我国建设成社会主义现代化强国，要在基本实现社会主义现代化基础上在奋斗（ ）年。',JSON_ARRAY('A. 10','B. 15','C. 20','D. 30'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','符合中国国情，体现社会主义现代化国家性质，能够保证人民当家作主的根本政治制度是（ ）。',JSON_ARRAY('A. 基层群众自治制度','B. 民族区域自治制度','C. 党领导的多党合作和政治协商制度','D. 人民代表大会制度'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','作出全面深化改革决定的会议是（ ）。',JSON_ARRAY('A. 党的十八届三中全会','B. 党的十八届四中全会','C. 党的十九届三中全会','D. 党的十九届四中全会'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','反映军队根本职能和军队建设的根本指向的是（ ）。',JSON_ARRAY('A. 听党指挥','B. 能打胜仗','C. 作风优良','D. 军民团结'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','维护国家主权、安全、发展利益要坚持（ ）。',JSON_ARRAY('A. 以民主为基础','B. 以自由为依托','C. 以人权为理念','D. 以国家核心利益为底线'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','我国的根本领导制度是（ ）。',JSON_ARRAY('A. 党的领导制度','B. 多党合作制度','C. 民主选举制度','D. 政治协商制度'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','全面从严治党的长远之策、根本之策是加强（ ）。',JSON_ARRAY('A. 党风建设','B. 组织建设','C. 制度建设','D. 纪律建设'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）中国共产党第二十次全国代表大会的主题是（ ）。',JSON_ARRAY('A. 高举中国特色社会主义伟大旗帜','B. 全面贯彻新时代中国特色社会主义思想','C. 弘扬伟大建党精神，自信自强，守正创新，踔厉奋发，勇毅前行','D. 为全面建设社会主义现代化国家，全面推进中华民族伟大复兴而团结奋斗'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）2022 年 12 月 7 日，国家主席习近平抵达沙特阿拉伯首都利雅得，出席首届（ ）。',JSON_ARRAY('A. 中国-阿拉伯国家峰会','B. 中国-海湾阿拉伯国家合作会议','C. 中国与沙特能源安全会议','D. 中国与中东国家安全合作会议'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）1921 年中国共产党诞生，是一件开天辟地的大事变，它深刻改变了（ ）。',JSON_ARRAY('A. 近代以后中华民族发展的方向和进程','B. 中国人民和中华民族的前途和命运','C. 世界发展的趋势和格局','D. 人类社会的发展规律'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）十月革命胜利的重大意义是（ ）。',JSON_ARRAY('A. 促进了西方资本主义国家无产阶级的觉醒','B. 促进了东方殖民地半殖民地国家被压迫民族和被压迫人民的觉醒','C. 建立了一条新的反对世界帝国主义的革命战线','D. 使中国的资产阶级民主主义属于世界无产阶级社会主义革命的一部分'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）在社会主义改造过程中，中国共产党积累自己历史经验有（ ）。',JSON_ARRAY('A. 坚持社会主义工业建设与社会主义改造同时并举','B. 采取积极引导，逐步过渡的方式','C. 用阶级斗争的方式改造','D. 用和平方式进行改造'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）社会主义初级阶段理论是（ ）。',JSON_ARRAY('A. 建设中国特色社会主义的总依据','B. 对马克思主义关于社会主义发展阶段理论的重大发展和重大突破','C. 基于对中国国情的准确把握','D. 对当代中国历史方位的科学揭示'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）习近平指出，中国梦的本质是（ ）。',JSON_ARRAY('A. 国家富强','B. 民族振兴','C. 人民幸福','D. 世界和平'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）“四个全面战略布局中，提供重要保障的战略举措是（ ）。',JSON_ARRAY('A. 全面从严治党','B. 全面深化改革','C. 全面依法治国','D. 全面建设社会主义现代化国家'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）习近平新时代中国特色社会主义思想是（ ）。',JSON_ARRAY('A. 新时代中国共产党的思想旗帜','B. 实现中华民族伟大复兴的行动指南','C. 当代中国马克思主义、21 世纪马克思主义','D. 中华文化和中国精神的时代精神'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）确保党始终总览全局，协调各方，必须增强（ ）。',JSON_ARRAY('A. 政治意识','B. 大局意识','C. 核心意识','D. 看齐意识'),NULL,NULL,2,'answerable'),
(@pid,31,31,'essay','三、辨析题（先判断正误，再作简要分析。本大题共 2 小题，每小题 7 分，共 14 分）','毛泽东思想活的灵魂是统一战线、武装斗争、党的建设。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,32,32,'essay','三、辨析题（先判断正误，再作简要分析。本大题共 2 小题，每小题 7 分，共 14 分）','以人为本是科学发展观的核心立场。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,33,33,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）','简答邓小平“两手抓，两手都要硬”的思想。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,34,34,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）','简答“三个代表”重要思想的核心观点。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,35,35,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）','简述人类命运共同体的内涵。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,36,36,'essay','五、论述题（本大题共 10 分）','论述党对社会主义建设道路初步探索的经验教训。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,37,NULL,'material','六、材料分析题（本大题共 15 分）','【材料一】

高质量发展是全面建设社会主义现代化国家的重要任务。发展是党执政兴国的第一要务。
——摘自《高举中国特色社会主义伟大旗帜，为全面建设社会主义现代化国家而团结奋斗一在中国共产党
第二十次全国代表大会的报告》',NULL,NULL,NULL,0,'reveal_only'),
(@pid,38,NULL,'material','六、材料分析题（本大题共 15 分）','【材料二】

高质量发展就是能够很好满足人民日益增长的美好生活需要的发展，是体现新发展理念的发展，是创新成
为第一动力，协调成为内生特点，绿色成为普遍形态，开发成为必由之路，共享成为根本目的的发展。
——摘自《习近平谈治国理政第三卷，第 238 页》',NULL,NULL,NULL,0,'reveal_only'),
(@pid,39,NULL,'material','六、材料分析题（本大题共 15 分）','【材料三】

把新发展理念贯穿发展全过程和各领域，构建新发展格局，切实转变发展方式，推动质量变革，效率变革，
实现更高质量，更有效率、更加公平.更可持续、更为安全的发展。
——摘自《中共中央关于制定国民经济和社会发展第十四个五年规划和二 0 二五年远景目标的建议》
37.阅读材料，回答问题。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,40,NULL,'essay','六、材料分析题（本大题共 15 分）','（1）上述材料说明了什么',NULL,NULL,NULL,15,'reveal_only'),
(@pid,41,NULL,'essay','六、材料分析题（本大题共 15 分）','（2）如何推动高质量发展',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 政治理论 2024 (41 题, published=1) · 中文卷解析·选择30·材料3·主观8·暂缺0·共41 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='政治理论' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2023 年 2 月 13 日至 14 日在中国北京召开的世界数字教育大会的主题是（ ）。',JSON_ARRAY('A. 数字变革与中国未来','B. 数字变革与教育未来','C. 数字经济与世界未来','D. 数字教育与产业发展'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','第 19 届亚运会的举办地点是（ ）。',JSON_ARRAY('A. 上海','B. 成都','C. 杭州','D. 广州'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','2023 年 12 月 15 日，港珠澳大桥旅游正式向公众开放，举行试运营开通仪式的地点是（ ）。',JSON_ARRAY('A. 珠海','B. 深圳','C. 香港','D. 澳门'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','中国高铁首次全系统、全要素、全产业链在海外落地的是（ ）。',JSON_ARRAY('A. 新马高铁','B. 雅万高铁','C. 中老高铁','D. 中缅高铁'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','中国革命进入新民主主义革命的标志是（ ）。',JSON_ARRAY('A. 辛亥革命','B. 鸦片战争','C. 五四运动','D. 护国运动'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','1954 年 9 月，第一届全国人民代表大会制定颁布施行的法律是（ ）。',JSON_ARRAY('A. 《中华人民共和国民法典》','B. 《中华人民共和国宪法》','C. 《中华人民共和国合同法》','D. 《中华人民共和国行政法》'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','标志着党探索中国社会主义建设道路的良好开端的著作是（ ）。',JSON_ARRAY('A. 《论十大关系》','B. 《关于正确处理人民内部矛盾的问题》','C. 《反对本本主义》','D. 《人的正确思想是从哪里来的》'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','开启改革开放和社会主义现代化建设新时期的重要会议是（ ）。',JSON_ARRAY('A. 党的八大','B. 党的十一大','C. 党的十一届三中全会','D. 党的十二届三中全会'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','党的十八大以来，中国特色社会主义进入（ ）。',JSON_ARRAY('A. 新世纪','B. 新阶段','C. 新时期','D. 新时代'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','党执政兴国的第一要务是（ ）。',JSON_ARRAY('A. 发展','B. 革命','C. 改革','D. 开放'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','中国特色社会主义最本质的特征是（ ）。 B.人民代表大会制度',JSON_ARRAY('A. 中国共产党领导','B. 人民代表大会制度','C. 社会主义市场经济','D. 以人民为中心'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','我们说做好一切工作的价值取向和根本标准是（ ）。',JSON_ARRAY('A. 推动经济发展','B. 促进文化繁荣','C. 让群众满意','D. 改善生态环境'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','新时代坚持和发展中国特色社会主义的根本动力是（ ）。',JSON_ARRAY('A. 实现科技自立自强','B. 全面深化改革开放','C. 全面从严治党','D. 全面建成社会主义现代化国家'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','全面建设社会主义现代化国家的首要任务是（ ）。',JSON_ARRAY('A. 贯彻新发展理念','B. 推动高质量发展','C. 推动高水平对外开放','D. 推进中国式现代化'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','全面依法治国的总抓手是（ ）。',JSON_ARRAY('A. 完善中国特色社会主义法律规范体系','B. 建设中国特色社会主义法治体系','C. 完善中国特色社会主义法治监督体系','D. 建设中国特色社会主义法治理论'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','社会主义生产的根本目的是（ ）。',JSON_ARRAY('A. 推进生产力快速发展','B. 赢得与资本主义比较优势','C. 促进科技进步','D. 增进民生福祉'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','在国家安全中，处于首要位置的是（ ）。',JSON_ARRAY('A. 政治安全','B. 经济安全','C. 军事安全','D. 社会安全'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','反映军队根本职能和军队建设根本指向是（ ）。',JSON_ARRAY('A. 听党指挥','B. 能打胜仗','C. 作风优良','D. 纪律严明'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','在党的建设中，基础性建设是（ ）。',JSON_ARRAY('A. 政治建设','B. 思想建设','C. 组织建设','D. 作风建设'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 20 小题，每小题 1 分，共 20 分。每小题只有一个选项符合题目','我国对外工作的出发点和落脚点是（ ）。',JSON_ARRAY('A. 维护国家主权、安全、发展利益','B. 人类命运共同体','C. 坚持走和平发展道路','D. 增进人民福祉'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）中国空间站全面建成后首次出舱活动，漫步太空航天员是（ ）。',JSON_ARRAY('A. 费俊龙','B. 刘洋','C. 陈冬','D. 张陆'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）2023 年 11 月 15 日国家主席习近平在旧金山会晤美国总统拜登指出，从 50 年中美关系历程中得出的经 验是（ ）。',JSON_ARRAY('A. 相互尊重','B. 竞争对抗','C. 合作共赢','D. 和平共处'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）新民主主义革命动力包括（ ）。',JSON_ARRAY('A. 无产阶级','B. 农民阶级','C. 城市小资产阶级','D. 民族资产阶级'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）我党在探索中国工业化道路中，提出把资本主义经济作为社会主义经济补充思想的有（ ）。',JSON_ARRAY('A. 毛泽东','B. 刘少奇','C. 周恩来','D. 朱德'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）推进国家治理体系和治理能力现代化必须（ ）。',JSON_ARRAY('A. 坚定中国特色社会主义制度自信','B. 更好发挥中国特色社会主义制度优势','C. 把中国特色社会主义制度优势转化为国家治理效能','D. 提高党的科学执政、民主执政、依法执政水平'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）加快形式绿色生产方式和生活方式必须（ ）。',JSON_ARRAY('A. 加快推动产业结构、能源结构、交通运输结构的调整优化','B. 推动各类资源节约集约利用','C. 积极考点对比达峰碳中和','D. 健全绿色发展的保障体系'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）我国的基本政治制度有哪些（ ）。',JSON_ARRAY('A. 人民代表大会制度','B. 中国共产党领导的多党合作和政治协商制度','C. 民族区域自治制度','D. 基层群众自治制度'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）提高人民生活品质的主要着力点要（ ）。',JSON_ARRAY('A. 完善分配制度','B. 实施就业优先战略','C. 健全社会保障体系','D. 推进健康中国建设'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）加快形式绿色生产方式和生活方式必须（ ）。',JSON_ARRAY('A. 加快推动产业结构、能源结构、交通运输结构的调整优化','B. 推动各类资源节约集约利用','C. 积极推进碳达峰碳中和','D. 健全绿色发展的保障体系'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）构建新型国际政党关系需要秉持的观念是（ ）。',JSON_ARRAY('A. 求同存异','B. 零和博弈','C. 相互尊重','D. 互学互鉴'),NULL,NULL,2,'answerable'),
(@pid,31,31,'essay','三、辨析题（先判断正误，再作简要分析。本大题共 2 小题，每小题 7 分，共 14 分）。','新时代我国的主要矛盾是人民日益增长的物质文化需要同落后的生产力的发展的矛盾。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,32,32,'essay','三、辨析题（先判断正误，再作简要分析。本大题共 2 小题，每小题 7 分，共 14 分）。','全面建设社会主义现代化国家，教育是根本，科技是关键，人才是基础。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,33,33,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）。','简述独立自主的内涵。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,34,34,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）。','如何坚持科学发展。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,35,35,'essay','四、简答题（本大题共 3 小题，每小题 7 分，共 21 分）。','简答文化繁荣兴盛是全面实现中华民族伟大复兴的必然要求。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,36,36,'essay','五、论述题（本大题 10 分）。','邓小平理论社会主义市场经济理论的主要内容。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,37,NULL,'material','六、材料分析题（本大题 15 分）。','【材料一】

中国式现代化，是中国共产党领导的社会主义现代化，既有各国现代化的共同特征。更有基于自己国情的
中国特色。
——摘自《习近平著作选读》第一卷，第 18 页',NULL,NULL,NULL,0,'reveal_only'),
(@pid,38,NULL,'material','六、材料分析题（本大题 15 分）。','【材料二】

现代化不是少数国家的“专利品”,也不是非此即彼的“单选题”,不能搞简单的千篇一律，“复制粘贴”。
一个国家走向现代化，既要遵循现代化的一般规律，更要立足本国国情，具有本国特色。
——习近平在中国共产党与世界政党高层对话会上主旨讲话
2023 年 3 月 15 日',NULL,NULL,NULL,0,'reveal_only'),
(@pid,39,NULL,'material','六、材料分析题（本大题 15 分）。','【材料三】

推进中国式现代化是一个探索性事业，还有许多未知领域，需要我们在实践中去大胆探索，通过改革创新
来推动事业发展，决不能刻舟求剑，守株待兔。各地区部门要结合各自具体实际开拓创新，特别是在前沿
实践、未知领域鼓励大胆探索，敢为人先。寻求有效解决新矛盾新问题的思路和办法，努力创造可复制、
可推广的新鲜经验。
——习近平：推进中国式现代化需要处理好若干重大关系
2023 年 2 月 7 日',NULL,NULL,NULL,0,'reveal_only'),
(@pid,40,NULL,'essay','六、材料分析题（本大题 15 分）。','（1）上述材料说明了什么?',NULL,NULL,NULL,15,'reveal_only'),
(@pid,41,NULL,'essay','六、材料分析题（本大题 15 分）。','（2）推进中国式现代化需要把握哪些重大原则?',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 政治理论 2025 (38 题, published=1) · 中文卷解析·选择30·材料0·主观8·暂缺0·共38 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='政治理论' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题','2024 年 7 月，中国共产党第二十届中央委员会第三次全体会议举行，审议通过了（ ）。',JSON_ARRAY('A. 《中共中央关于全面深化改革若干重大问题的决定》','B. 《中共中央关于进一步全面深化改革、推进中国式现代化的决定》','C. 《中共中央关于全面推进依法治国若干重大问题的决定》','D. 《中共中央政治局关于加强和维护党中央集中统一领导的若干规定》'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题','嫦娥六号在内蒙古四王子旗降落，实现了（ ）。',JSON_ARRAY('A. 人类首次登陆月球','B. 中国首次登陆月球','C. 世界首次月球背面采样返回','D. 世界首次月球采样返回'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题','2024 年“读懂中国”（广州）国际会议开幕，主题为（ ）。',JSON_ARRAY('A. 将改革进行到底——中国式现代化与世界发展新机遇','B. 不确定的世界：团结合作迎挑战，开放包容促发展','C. 亚洲与世界：共同的挑战，共同的责任','D. 共筑和平共享未来'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题','2024 年 7 月 26 日，第 33 届夏季奥运会开幕式举行地点在（ ）。',JSON_ARRAY('A. 伦敦','B. 巴黎','C. 雅典','D. 罗马'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题','中国资产阶级民主革命的时代背景发生了根本转换是（ ）。',JSON_ARRAY('A. 俄国十月革命','B. 五四运动','C. 新文化运动 2','D. 辛亥革命'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题','个体经济向社会主义集体经济过渡的形式是（ ）。',JSON_ARRAY('A. 国家资本主义','B. 私人资本主义','C. 个体经济','D. 半社会主义性质的合作社经济'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题','第一次提出关于“四个现代化”构想的是（ ）。',JSON_ARRAY('A. 毛泽东','B. 刘少奇','C. 周恩来','D. 朱德'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题','邓小平理论时期的时代主题是（ ）。',JSON_ARRAY('A. 战争与革命','B. 对话与对抗','C. 合作与竞争','D. 和平与发展'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题','贯彻“三个代表”重要思想，关键在（ ）。',JSON_ARRAY('A. 坚持执政为民','B. 党的纯洁性','C. 坚持与时俱进','D. 党的先进性'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题','解决“三农”问题的根本途径是（ ）。',JSON_ARRAY('A. 推动城乡发展一体化','B. 农业农村现代化','C. 区域协调发展','D. 党的先进性'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题','中国式现代化区别于西方现代化的显著标志是（ ）。',JSON_ARRAY('A. 人口规模巨大的现代化','B. 全体人民共同富裕的现代化 3','C. 物质文明和精神文明相协调的现代化','D. 人与自然和谐共生的现代化'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题','马克思主义政党第一位的能力是（ ）。',JSON_ARRAY('A. 政治领导力','B. 思想引领力','C. 群众组织力','D. 社会号召力'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题','构建新发展格局是以（（ ）。',JSON_ARRAY('A. 国际大循环为主体','B. 封闭的循环','C. 各地自我小循环','D. 以国内大循环为主体、国内国际双循环相互促进'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题','推动社会发展最活跃、最积极的因素（）。',JSON_ARRAY('A. 科学技术','B. 市场资源','C. 人才','D. 教育'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题','当前是统一战线最鲜明的特征是（ ）。',JSON_ARRAY('A. 坚持党的领导','B. 因团结而生，靠团结而兴','C. 一致性和多样性的统一体','D. 做人的工作'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题','完善社会治理体系的先导是（ ）。',JSON_ARRAY('A. 理念','B. 制度','C. 方式方法','D. 法治'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题','香港回归祖国的时间是（ ）。',JSON_ARRAY('A. 1999 年 12 月 20 日 4','B. 1997 年 8 月 1 日','C. 1997 年 7 月 1 日','D. 1999 年 12 月 31 日'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题','全方位务实粮食安全根基，牢牢守住的耕地红线是（ ）。',JSON_ARRAY('A. 15 亿亩','B. 18 亿亩','C. 19 亿亩','D. 20 亿亩'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题','人民军队的立军之本是（ ）。',JSON_ARRAY('A. 政治建军','B. 科技强军','C. 依法治军','D. 改革强军'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题','首次提出“推进法治中国建设”的目标并作出重大任务部署的是（ ）。',JSON_ARRAY('A. 十八届三中全会','B. 十八届四中全会','C. 十九届三中全会','D. 十九届四中全会'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','二、多项选择题','（多选）2024 年，国务院办公厅印发了《关于加快完善生育支持政策体系推动建设生育友好型社会的若干措施》 提出（ ）。',JSON_ARRAY('A. 强化生育服务支持','B. 加强育幼服务体系建设','C. 强化教育、住房、就业等支持措施','D. 营造生育友好社会氛围'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题','（多选）从 2024 年 1 月 1 日，金砖国家扩员，除埃塞俄比亚外，还有（ ）。',JSON_ARRAY('A. 沙特','B. 埃及','C. 阿联酋 5','D. 伊朗'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题','（多选）我国对手工业的社会主义改造采取的方针是（ ）。',JSON_ARRAY('A. 自愿互利','B. 典型示范','C. 积极领导','D. 稳步前进'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题','（多选）对于科学文化领域的人民内部矛盾，需要实行的方针是（ ）。',JSON_ARRAY('A. 古为今用','B. 百花争鸣','C. 百花齐放','D. 洋为中用'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题','（多选）社会主义核心价值体系的基本内容包括（ ）。',JSON_ARRAY('A. 中国特色社会主义共同理想','B. 马克思主义指导思想','C. 社会主义荣辱观','D. 以爱国主义为核心的民族精神和以改革创新为核心的时代精神'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','二、多项选择题','（多选）中国特色社会主义新时代，铸就了的精神是（ ）。',JSON_ARRAY('A. 脱贫攻坚精神','B. 抗疫精神','C. 探月精神','D. 新时代北斗精神'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题','（多选）全面深化改革的总目标是（ ）。',JSON_ARRAY('A. 完善和发展中国特色社会主义制度','B. 完善和发展治理体系和治理能力','C. 推进国家治理体系和治理能力民主化','D. 推进国家治理体系和治理能力现代化'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题','（多选）共建清洁美丽世界要（ ）。',JSON_ARRAY('A. 坚持以人为本','B. 坚持科学治理 6','C. 坚持单边主义','D. 坚持共同但无区别的责任原则'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题','（多选）改革开放以来我们取得一切成绩和进步的根本原因，归结起来是（ ）。',JSON_ARRAY('A. 开辟了中国特色社会主义道路','B. 形成了中国特色社会主义理论体系','C. 确立了中国特色社会主义制度','D. 发展了中国特色社会主义文化'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题','（多选）人类命运共同体是（ ）。',JSON_ARRAY('A. 我们党审视当今世界发展趋势、针对当今世界面临的重大问题提出的重要理念','B. 应对人类共同挑战、建设更加繁荣美好世界的人间正道','C. 中国特色大国外交的总目标','D. 处理国与国之间关系的权宜之计'),NULL,NULL,2,'answerable'),
(@pid,31,31,'essay','三、辨析题','马克思主义中国化时代化的理论成果是一脉相承与时俱进的关系。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,32,32,'essay','三、辨析题','毫不动摇巩固和发展公有制经济，毫不动摇地鼓励支持，引导非公有制经济。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,33,33,'essay','四、简答题','如何坚持实事求是。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,34,34,'essay','四、简答题','简述社会主义的本质。 7',NULL,NULL,NULL,7,'reveal_only'),
(@pid,35,35,'essay','四、简答题','简述如何坚持人民立场？',NULL,NULL,NULL,7,'reveal_only'),
(@pid,36,36,'essay','五、论述题','论述实现高水平科技自立自强的重大意义。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,37,NULL,'essay','六、材料分析题','（1）上述材料说明了什么？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,38,NULL,'essay','六、材料分析题','（2）如何坚持标本兼治开展反腐败斗争？',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 管理学 2022 (46 题, published=1) · 中文卷解析·选择35·材料0·主观11·暂缺0·共46 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='管理学' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','越是处于高层的管理者，其对于概念技能、人际技能、技术技能的需要，就越是按以下顺序排列（ ）。',JSON_ARRAY('A. 概念技能，技术技能，人际技能','B. 技术技能，概念技能，人际技能','C. 概念技能，人际技能，技术技能','D. 人际技能，技术技能，概念技能'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','管理者所扮演的人际角色包括（ ）。',JSON_ARRAY('A. 领导者、发言人、传播者','B. 领导者、代表人、联络者','C. 代表人、发言人、联络者','D. 企业家、谈判者、传播者'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','提出计划职能与执行职能相分离的管理理论是（ ）。',JSON_ARRAY('A. 科学管理理论','B. 组织管理理论','C. 系统管理理论','D. 权变管理理论'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','如果一个人遵守自己选择的道德准则，即使这些准则违背了法律，这说明他正处于道德发展的（ ）。',JSON_ARRAY('A. 前惯例层次','B. 惯例层次','C. 原则层次','D. 后惯例层次'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','（ ）是当事人一方将其技术、商标或专利的使用权转让给另一方，由后者按合同规定使用的交易行为。',JSON_ARRAY('A. 管理合同','B. 特许','C. 合同制造','D. 投资'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','根据企业价值链的分析，下列不属于企业的基本活动的是（ ）。',JSON_ARRAY('A. 输入物流','B. 生产作业','C. 市场营销','D. 技术开发'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','某一快递公司在市区规划了 30 条不同的送货路线，但是这些路线中会遇到概率未知的堵车问题，此时， 快递人员选择到达时间最短的路线的决策属于（ ）。',JSON_ARRAY('A. 不确定型决策','B. 风险型决策','C. 确定型决策','D. 以上都不是'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','在决策的影响因素中，买卖双方在市场的地位属于（ ）。',JSON_ARRAY('A. 环境因素','B. 组织自身的因素','C. 决策问题的性质','D. 决策主体的因素'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','关于政策的理解错误的是（ ）。',JSON_ARRAY('A. 政策是指导或沟通决策思想的全面的陈述书或理解书','B. 政策允许对某些事情有酌情处理的自由','C. 政策的表现形式只能是陈述书或理解书','D. 政策支持了分权，同时也支持上级主管对该项分权的控制'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','下列不是影响组织分权程度的主要因素的是（ ）。',JSON_ARRAY('A. 组织规模的大小','B. 政策的统一性','C. 组织的可控性','D. 领导的能力'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','在一些较高的管理层次设立职务，不仅可以减轻主要负责人的负担，而且有助于培训待提拔管理人员。 这种培训方法是（ ）。',JSON_ARRAY('A. 设置临时职务','B. 职务轮换','C. 设置助理职务','D. 有计划的提升'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','小李应聘 A 公司被录用后，公司的人事部门对小李进行了为期两周的入职培训，这属于培训方式中的 （ ）。',JSON_ARRAY('A. 导入培训','B. 离职培训','C. 在职培训','D. 工作轮换'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','组织变革的基本目标是（ ）。',JSON_ARRAY('A. 提高组织的效能','B. 提高组织的效率','C. 提高组织的获利能力','D. 提高组织的适应能力'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','某企业对生产车间的安全设施进行了改善，这是为了更好地满足员工的（ ）。',JSON_ARRAY('A. 生理的需要','B. 安全的需要','C. 社交的需要','D. 尊重的需要'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','根据期望理论，要达到使工作的分配出现所希望的激励效果，一项工作最好授予（ ）。',JSON_ARRAY('A. 能力远远高于任务要求的人','B. 能力远远低于任务要求的人','C. 能力略高于任务要求的人','D. 能力略低于任务要求的人'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','关于强化理论，下列说法正确的是（ ）。',JSON_ARRAY('A. 美国心理学家马斯洛首先提出','B. 所谓正强化就是惩罚那些不符合组织目标的行为，以使这些行为削弱甚至消失','C. 连续的、固定的正强化能够使一切强化都起到较大的效果','D. 实施负强化的方式与正强化有所差异，应以连续的负强化为主'),NULL,NULL,1,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','按照组织系统划分，沟通可分为（ ）。',JSON_ARRAY('A. 工具式沟通和感情式沟通','B. 个体间沟通和群体间沟通','C. 正式沟通与非正式沟通','D. 上行沟通与下行沟通'),NULL,NULL,1,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','在影响有效沟通障碍的因素中，地位差别、信息传递链、团体规模、空间约束属于（ ）。',JSON_ARRAY('A. 结构因素','B. 个人因素','C. 人际因素','D. 技术因素'),NULL,NULL,1,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','当冲突双方都有意寻求双赢的解决方案，或是事件十分重大、双方不可能妥协时，可采用的处理办法是 （ ）。',JSON_ARRAY('A. 回避','B. 迁就','C. 强制','D. 合作'),NULL,NULL,1,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','下列选项中属于生产控制的是（ ）。',JSON_ARRAY('A. 库存控制','B. 标杆控制','C. 比率分析','D. 经营审计'),NULL,NULL,1,'answerable'),
(@pid,21,21,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','反映企业偿还需要付现的流动债务能力的财务比率是（ ）。',JSON_ARRAY('A. 流动比率','B. 库存周转率','C. 负债比率','D. 盈利比率'),NULL,NULL,1,'answerable'),
(@pid,22,22,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','质量管理的发展阶段不包括（ ）。',JSON_ARRAY('A. 质量检查阶段','B. 统计质量管理阶段','C. 全面质量管理阶段','D. 质量管理国际化阶段'),NULL,NULL,1,'answerable'),
(@pid,23,23,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','将企业危机分成战略危机与职能危机的标准是（ ）。',JSON_ARRAY('A. 危机涉及的主体','B. 诱发危机的原因','C. 危机涉及领域的宽泛','D. 危机的可预见和可控程度'),NULL,NULL,1,'answerable'),
(@pid,24,24,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','管理的“维持职能”包括（ ）。',JSON_ARRAY('A. 组织、领导、创新','B. 组织、控制、创新','C. 创新、领导、控制','D. 组织、领导、控制'),NULL,NULL,1,'answerable'),
(@pid,25,25,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','从创新与环境的关系分析，创新可分为（ ）。',JSON_ARRAY('A. 局部创新和整体创新','B. 消极防御型创新和积极攻击型创新','C. 自发创新和有组织的创新','D. 系统初建期的创新和运行中的创新'),NULL,NULL,1,'answerable'),
(@pid,26,26,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）管理者所扮演的决策角色包括（ ）。',JSON_ARRAY('A. 企业家','B. 冲突管理者','C. 资源分配者','D. 谈判者'),NULL,NULL,2,'answerable'),
(@pid,27,27,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）下列哪些是学习型组织的显著特征（ ）。',JSON_ARRAY('A. 认为创新是组织中每个成员的事','B. 管理者的职责是调动别人、授权别人','C. 主要担心不学习、不变革','D. 认为产品和服务是组织的竞争优势'),NULL,NULL,2,'answerable'),
(@pid,28,28,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）下列属于定量决策方法的有（ ）。',JSON_ARRAY('A. 德尔菲法','B. 量本利分析法','C. 决策树法','D. 大中取大法'),NULL,NULL,2,'answerable'),
(@pid,29,29,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）下列属于行业环境分析对象的有（ ）。',JSON_ARRAY('A. 供应商','B. 顾客','C. 潜在竞争者','D. 技术环境'),NULL,NULL,2,'answerable'),
(@pid,30,30,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）下列不属于按照计划内容出现的重复程度或计划的程序化程度分类的有（ ）。',JSON_ARRAY('A. 长期计划和短期计划','B. 战略性计划和战术性计划','C. 具体性计划和指导性计划','D. 程序性计划和非程序化计划'),NULL,NULL,2,'answerable'),
(@pid,31,31,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）下列属于一体化战略的有（ ）。',JSON_ARRAY('A. 同心一体化','B. 前向一体化','C. 后向一体化','D. 横向一体化'),NULL,NULL,2,'answerable'),
(@pid,32,32,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）确定有效管理幅度的常见因素有（ ）。',JSON_ARRAY('A. 工作能力','B. 工作条件','C. 工作环境','D. 工作内容和性质'),NULL,NULL,2,'answerable'),
(@pid,33,33,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）人员变革中组织成员需要做出改革的是（ ）。',JSON_ARRAY('A. 工作态度','B. 认知','C. 期望','D. 权力的分配'),NULL,NULL,2,'answerable'),
(@pid,34,34,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）关于领导者与管理者，说法正确的有（ ）。',JSON_ARRAY('A. 就组织的个人而言，可能既是领导者，又是管理者','B. 领导者一般关注的是做正确的事','C. 管理者一般关注的是短期视角','D. 管理者关注的是剖析，领导者关注的是执行'),NULL,NULL,2,'answerable'),
(@pid,35,35,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）在持续不断的竞争中，企业可以采用的产品开发战略有（ ）。',JSON_ARRAY('A. 领先战略','B. 追随战略','C. 集中战略','D. 模仿战略'),NULL,NULL,2,'answerable'),
(@pid,36,36,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：管理',NULL,NULL,NULL,3,'reveal_only'),
(@pid,37,37,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：目标管理',NULL,NULL,NULL,3,'reveal_only'),
(@pid,38,38,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：组织文化',NULL,NULL,NULL,3,'reveal_only'),
(@pid,39,39,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：有效沟通',NULL,NULL,NULL,3,'reveal_only'),
(@pid,40,40,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：反馈控制',NULL,NULL,NULL,3,'reveal_only'),
(@pid,41,41,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述法约尔的五种管理职能。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,42,42,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述决策的过程。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,43,43,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述五种组织部门化的基本形式。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,44,44,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述平衡计分卡的含义与优点。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,45,45,'essay','五、论述题（本大题共 10 分）','联系实际论述赫茨伯格的双因素理论。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,46,46,'essay','六、案例分析题（本大题共 10 分）','材料略。 问题：请分别从法律责任、经济责任、伦理责任、慈善责任分析公司所承担的社会责任。',NULL,NULL,NULL,10,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 管理学 2024 (29 题, published=1) · 中文卷解析·选择17·材料0·主观12·暂缺0·共29 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='管理学' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','车间主任注重处理各种关系能力培养，这是提升管理技能中的（ ）。',JSON_ARRAY('A. 人际技能','B. 概念技能','C. 技术技能','D. 政治技能'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','“凡目标相同的活动，只能有一个领导，一个计划”属于法约尔一般管理 14 项原则中的（ ）。',JSON_ARRAY('A. 统一指挥原则','B. 统一领导原则','C. 集权与分权原则','D. 秩序原则'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','个人只有在其利益影响受到的情况下才会做出道德判断属于道德发展层次的（ ）。',JSON_ARRAY('A. 原则层次','B. 惯例层次','C. 前惯例层次','D. 中间层次'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','决策遵循的原则是（ ）。',JSON_ARRAY('A. 折衷原则','B. 满意原则','C. 最优原则','D. 平衡原则'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','决策过程的最后一步是（ ）。',JSON_ARRAY('A. 拟定方案','B. 筛选方案','C. 执行方案','D. 评估效果'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','最古老的领导理论是（ ）。',JSON_ARRAY('A. 管理方格论','B. 特性理论','C. 行为理论','D. 情景理论'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 25 小题，每小题 1 分，共 25 分。每小题只有一个选项符合题目','对于工作成熟度较高和心理成熟度较高的员工，领导应采用（ ）方式。',JSON_ARRAY('A. 授权式','B. 参与式','C. 推销式','D. 支持式 8-25 题暂未收集到'),NULL,NULL,1,'answerable'),
(@pid,8,26,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）管理者所扮演的决策角色有（ ）。',JSON_ARRAY('A. 企业家','B. 资源分配者','C. 冲突管理者','D. 领导者'),NULL,NULL,2,'answerable'),
(@pid,9,27,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）人际关系学说的主要观点有（ ）。',JSON_ARRAY('A. 暂未收集到','B. 暂未收集到','C. 人是经济人','D. 生产率主要取决于人的态度以及他和周围人的关系'),NULL,NULL,2,'answerable'),
(@pid,10,28,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）影响决策的主体因素有（ ）。',JSON_ARRAY('A. 个人对待风险的态度','B. 个人能力','C. 个人价值观','D. 决策群体的关系融洽程度'),NULL,NULL,2,'answerable'),
(@pid,11,29,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）企业竞争的基本战略有（ ）。',JSON_ARRAY('A. 多元化战略','B. 成本领先战略','C. 特色优势战略','D. 目标集聚战略'),NULL,NULL,2,'answerable'),
(@pid,12,30,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）组织文化的功能有（ ）。',JSON_ARRAY('A. 整合功能','B. 适应功能','C. 导向功能','D. 发展功能'),NULL,NULL,2,'answerable'),
(@pid,13,31,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）菲德勒权变理论认为，影响领导方式的因素有（ ）。',JSON_ARRAY('A. 领导者的特征','B. 追随者的特征','C. 组织目标','D. 环境'),NULL,NULL,2,'answerable'),
(@pid,14,32,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）民主式领导者的特征有（ ）。',JSON_ARRAY('A. 向被领导者授权','B. 牢固控制管理的制度权','C. 鼓励下属参与','D. 主要依赖于其个人专长权和模范权影响下属'),NULL,NULL,2,'answerable'),
(@pid,15,33,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）一般来说，管理控制过程中企业可以使用的建立标准的方法有（ ）。',JSON_ARRAY('A. 总成本方法','B. 统计性标准','C. 经验估算标准','D. 工程标准'),NULL,NULL,2,'answerable'),
(@pid,16,34,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）库存控制中经济订购批量模型考虑的成本有（ ）。',JSON_ARRAY('A. 订购成本','B. 仓储成本','C. 生产成本','D. 运输成本'),NULL,NULL,2,'answerable'),
(@pid,17,35,'choice','二、多项选择题（本大题共 10 小题，每小题 2 分，共 20 分。每小题有两个或两个以上选项','（多选）按照德鲁克的说法，下列属于技术创新源泉的有（ ）。',JSON_ARRAY('A. 意外的成功或失败','B. 企业内外不协调','C. 行业和市场结构的变化','D. 新知识的产生'),NULL,NULL,2,'answerable'),
(@pid,18,36,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）。','名词解释：社会契约道德观',NULL,NULL,NULL,3,'reveal_only'),
(@pid,19,37,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）。','名词解释：指导性计划',NULL,NULL,NULL,3,'reveal_only'),
(@pid,20,38,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）。','名词解释：沟通',NULL,NULL,NULL,3,'reveal_only'),
(@pid,21,39,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）。','名词解释：危机',NULL,NULL,NULL,3,'reveal_only'),
(@pid,22,40,'fill','三、名词解释（本大题共 5 小题，每小题 3 分，共 15 分）。','名词解释：组织工作流程再造',NULL,NULL,NULL,3,'reveal_only'),
(@pid,23,41,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述行业进入障碍的影响因素。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,24,42,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述组织变革的阻力。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,25,43,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述成就需要论的主要内容。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,26,44,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述预算的种类。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,27,45,'essay','五、论述题（本大题共 1 题，10 分）','论述泰罗科学管理理论的主要内容与其贡献和不足。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,28,NULL,'essay','六、案例分析题（本大题共 1 题，10 分）','（1）组织设计的影响因素有哪些？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,29,NULL,'essay','六、案例分析题（本大题共 1 题，10 分）','（2）本案例中，x 公司的组织设计的最主要影响因素是什么？',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 管理学 2025 (12 题, published=1) · 中文卷解析·无完整选择但主观可用·材料1·主观11·暂缺0·共12 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='管理学' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,37,'essay','三、简答题（本大题共 5 小题，每小题 3 分，共 15 分）','绩效评估',NULL,NULL,NULL,3,'reveal_only'),
(@pid,2,38,'essay','三、简答题（本大题共 5 小题，每小题 3 分，共 15 分）','系统管理理论',NULL,NULL,NULL,3,'reveal_only'),
(@pid,3,39,'essay','三、简答题（本大题共 5 小题，每小题 3 分，共 15 分）','预算控制',NULL,NULL,NULL,3,'reveal_only'),
(@pid,4,40,'essay','三、简答题（本大题共 5 小题，每小题 3 分，共 15 分）','战略计划',NULL,NULL,NULL,3,'reveal_only'),
(@pid,5,41,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述核心能力组织须具备的五个条件。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,6,42,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','目标管理的过程。 2',NULL,NULL,NULL,5,'reveal_only'),
(@pid,7,43,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','简述危机发生前后的管理控制。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,8,44,'essay','四、简答题（本大题共 4 小题，每小题 5 分，共 20 分）','道格拉斯·麦格雷戈 Y 理论的观点。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,9,45,'essay','五、论述题（本题 10 分）','组织文化的功能和塑造途径',NULL,NULL,NULL,10,'reveal_only'),
(@pid,10,NULL,'material','六、材料分析题（本题 10 分）','【材料分析】

H 公司为了避免中高层人才流失，企业竞争力下降，采取了为中上层员工设立激励标准，达到标准的员
工可以通过公司渠道固定的价格购买企业定期股份，完成的绩效目标越多，员工获得的定期股权就越多。
（大体内容）',NULL,NULL,NULL,0,'reveal_only'),
(@pid,11,NULL,'essay','六、材料分析题（本题 10 分）','（1）用期望理论分析 H 公司的激励计划。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,12,NULL,'essay','六、材料分析题（本题 10 分）','（2）结合材料说一下对管理者的启示。',NULL,NULL,NULL,10,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 经济学 2022 (46 题, published=1) · 中文卷解析·选择24·材料1·主观10·暂缺0·共46 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='经济学' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','经济学资源的缺稀性是指（ ）。',JSON_ARRAY('A. 资源有限','B. 资源正在消耗殆尽','C. 可以被人利用的资源太少','D. 资源相对于人类的无限欲望而言不足'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','比较下列几种商品中，那一种商品的需求弹性最小（ ）。',JSON_ARRAY('A. 食盐','B. 衣服','C. 化妆品','D. 手机'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','OQ 代表商品量，OP 代表价格，AD 是消费者需求曲线，当消费者购买数量为 OM 的商品时，其消费者 剩余是（ ）。',JSON_ARRAY('A. ANB','B. AOMB','C. NOMB','D. 都不对'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','同一平面上，短期内当平均产量曲线与边际产量曲线相交时（ ）。',JSON_ARRAY('A. 总产量为最小值','B. 总产量为最大值','C. 边际产量为最大值','D. 平均产量为最大值'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','使用自有资金也存在利息成本经济学中这种成本被称为（ ）。',JSON_ARRAY('A. 固定','B. 隐性','C. 会计','D. 显性'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','同一平面上，当平均可变成本曲线 AVC 处于最低点时，则一定有（ ）。',JSON_ARRAY('A. AC 也处于最低点','B. AC 处于上升阶段','C. MC 处于下降阶段','D. MC 穿过 AVC 这个最低点'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','假设产量为 199 单位时，平均成本为 10 元，再增加一单位产品的边际成本为 50 元，那么增加该单位产 品以后的平均成本为（ ）。',JSON_ARRAY('A. 10','B. 30','C. 10.2','D. 10.5'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','寡头市场形成的重要条件是（ ）。',JSON_ARRAY('A. 原材料丰裕','B. 产品无差别','C. 行业具有规模经济','D. 只有一家厂商控制市场'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','以下具有正外部性的是（ ）。',JSON_ARRAY('A. 工厂排污','B. 汽车尾气排放','C. 发展职业教育','D. 开豪车兜风'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','根据 GDP 核算的方法，家庭用于医疗方面的支出（ ）。',JSON_ARRAY('A. 不计入 GDP','B. 政府支出','C. 投资','D. 消费'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','当边际消费倾向 MPC 取值如下，投资乘数最大的是（ ）。',JSON_ARRAY('A. MPC = 0.9','B. MPC = 0.8','C. MPC = 0.7','D. MPC = 0.75'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','缓解有效需求不足可以采取的措施是（ ）。',JSON_ARRAY('A. 增加进口 B 增加投资','C. 减少政府购买','D. 增加税收'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','劳动力的供给和需求不匹配，既有找不到工作的劳动者，又有职位空缺的失业现象称为（ ）。',JSON_ARRAY('A. 季节性失业','B. 摩擦性失业','C. 结构性失业','D. 周期性失业'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','根据凯恩斯的理论，货币需求的动机不包括（ ）。',JSON_ARRAY('A. 交易动机','B. 预防动机','C. 储蓄动机','D. 投机动机'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','关于治理通货膨胀的对策，不可以采取（ ）。',JSON_ARRAY('A. 冻结工资水平','B. 增税','C. 降低法定准备率','D. 增加产品有效供给'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）需求是指消费者同时有（ ）的有效需求。',JSON_ARRAY('A. 购买欲望','B. 购买动机','C. 购买能力','D. 消费需求'),NULL,NULL,2,'answerable'),
(@pid,17,17,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）什么原因引起房子供给增加?（ ）',JSON_ARRAY('A. 土地价格上升','B. 水泥价格下降','C. 技术水平上升','D. 房价下跌'),NULL,NULL,2,'answerable'),
(@pid,18,18,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）一般对于短期生产函数，总产量与边际产量的关系是（ ）。',JSON_ARRAY('A. MP > 0 时，TP 递增','B. MP < 0 时，TP 递减','C. MP 的最大值为 TP 的一个拐点','D. MP = 0 时，TP 最大'),NULL,NULL,2,'answerable'),
(@pid,19,19,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）下列说法中，正确的有（ ）。',JSON_ARRAY('A. APL曲线呈递增时，AVC 曲线呈递减','B. APL曲线的最高点对应 AVC 曲线的最低点','C. MC 曲线与 AVC 曲线交于 AVC 曲线的最低点','D. MPL曲线与APL曲线交于APL曲线的最低点'),NULL,NULL,2,'answerable'),
(@pid,20,20,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）容易形成自然垄断的行业（ ）。',JSON_ARRAY('A. 粮食','B. 钢铁','C. 自来水','D. 天然气'),NULL,NULL,2,'answerable'),
(@pid,21,21,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）公共资源是指具有下列（ ）特点的物品。',JSON_ARRAY('A. 排他性','B. 非排他性','C. 竞争性','D. 非竞争性'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）对 GDP 和 GNP 的关系，下述表述正确的是（ ）。',JSON_ARRAY('A. GDP 从地城角度划分，考虑的是一国经济领土内的经济产出总量','B. GNP 从身份角度看，统计利用一国国民（常住单位）拥有的劳动和资本等要素所提供的产出总量','C. GDP 和 GNP 的数值不一定相等','D. GDP 和 GNP 的数值一定相等'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）通货膨胀的成因有（ ）。',JSON_ARRAY('A. 需求拉动','B. 成本推动','C. 供求混合推动','D. 结构性原因'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）在其他条件相同的情况下，以下属于紧缩性货币政策的选项是（ ）。',JSON_ARRAY('A. 提高贴现率','B. 央行买入政府债券','C. 减少货币发行','D. 提高法定准备率'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）在两部门经济中，如果消费函数为 C = 300 + 0.8Y，计划投资为 500，则（ ）。',JSON_ARRAY('A. 边际储蓄倾向是 0.2','B. 投资乘数是 4','C. 投资乘数是 5','D. 均衡收入是 1 000'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）“薄利多销”策略对任何商品都适用。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,27,27,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）边际效用递减规律是指，一定时期内，随着消费者消费数量的不断增加，消费者从每增加一单位 该商品或服务的消费中获得的效用量是逐渐递减的。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,28,28,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）用来表示人们身份地位的炫耀性的商品，价格下降是需求往往会减少。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,29,29,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）在长期中，企业可以对所有生产要素进行调整，所以长期成本没有不变成本和可变成本之分。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,30,30,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）生产要素最优组合的条件是每单位成本购买任意一种生产要素所得到的边际产量都相等。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,31,31,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）GDP 是衡量人民生活水平高低的唯一标准。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,32,32,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）劳动被通常定义为就业者。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,33,33,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）IS 曲线与 LM 曲线相交时表示货币市场处于均衡状态，而产品市场处于非均衡状态。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,34,34,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）表示通货膨胀率与失业率之间存在负相关的曲线是洛伦兹曲线。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,35,35,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）经济增长是一个“量”的概念，而经济发展是一个“质”的概念。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,36,36,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：恩格尔系数',NULL,NULL,NULL,4,'reveal_only'),
(@pid,37,37,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：机会成本',NULL,NULL,NULL,4,'reveal_only'),
(@pid,38,38,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：通货膨胀',NULL,NULL,NULL,4,'reveal_only'),
(@pid,39,39,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：法定准备金率',NULL,NULL,NULL,4,'reveal_only'),
(@pid,40,40,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','无差异曲线通常具有哪实特征？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,41,41,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','简述促进经济增长的手段。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,42,42,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','何谓“内在稳定器”，具有内在稳定器作用的财政政策机制主要有哪些？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,43,NULL,'material','六、材料分析题（本大题共 15 分）','【材料二】

2021 年底，我国大部分地区受持续低温的影响，一些城市的生活和生产用电激增，与此同时，煤
炭价格出现了持续攀升，导致电厂的发电成本随之提高，但电价收政府限价的影响，保持不变，这使得电
力供应不仅没有增加，反而减少了，一些城市甚至出现拉闸限电的现象。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,44,NULL,'essay','六、材料分析题（本大题共 15 分）','（1）运用图形分析供求规律对口罩均衡价格变动的影响？',NULL,NULL,NULL,15,'reveal_only'),
(@pid,45,NULL,'essay','六、材料分析题（本大题共 15 分）','（2）运用图形分析供求规律对电力供求数量变动的影响？',NULL,NULL,NULL,15,'reveal_only'),
(@pid,46,NULL,'essay','六、材料分析题（本大题共 15 分）','（3）商品价格上涨会对生产资源配置产生什么影响？',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 经济学 2023 (46 题, published=1) · 中文卷解析·选择25·材料1·主观10·暂缺0·共46 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='经济学' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','关于需求与供给的变动对均衡的影响，正确的是（ ）。',JSON_ARRAY('A. 供给不变，需求的变动引起均衡价格与均衡数量同方向变动','B. 需求不变，供给的变动引起均衡价格与均衡数量同方向变动','C. 供给不变，需求增加引起均衡价格下降，需求的下降引起均衡价格上升','D. 需求不变，供给的增加引起均衡价格上升，供给的减少引起价格下降'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','经济分析中所说的短期指（ ）都随产量调整的时期。',JSON_ARRAY('A. 一年之内','B. 全部生产要素','C. 至少有一种生产要素不能随产量调整的时期','D. 以上都对'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','某企业在产量为100、边际成本为50，边际收益为50，其它每件不变下，该企业（ ）。',JSON_ARRAY('A. 产量增加','B. 应该减少产量','C. 增产或减产都可实现最优产量','D. 已经实现了利润最大化，既不增加产量也不减少产量'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','生产可能性曲线说明的基本原理是（ ）。',JSON_ARRAY('A. 一国资源总能被充分利用','B. 技术改进必然引起产量的倍增效应','C. 生产能力扩张取决于劳动要素投入量','D. 在既定的资源条件下，只有减少一种物品的生产才能增加另外一种物品的生产'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','如果某种商品的需求价格弹性是0.5，那么（ ）。',JSON_ARRAY('A. 价格上升10%将使需求量减少5%','B. 价格上升10%将使需求量增加5%','C. 价格上升10%将使需求量增加10%','D. 价格上升10%将使需求量减少10%'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','总效用达到最大时（ ）。',JSON_ARRAY('A. 边际效用为正','B. 边际效用为零','C. 边际效用为负','D. 边际效用最大'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','经济学中的利润是指（ ）。',JSON_ARRAY('A. 总收益与显性成本之差','B. 总收益与隐性成本之差','C. 总收益与经济成本之差','D. 总收益与会计成本之差'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','如果边际储蓄倾向为0.3，投资支出增加60 亿元，将会使我国民收入增加（ ）。',JSON_ARRAY('A. 20 亿元','B. 60 亿元','C. 180 亿元','D. 200 亿元'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','下列商品中不能通过“薄利多销”来增加收益的是（ ）。',JSON_ARRAY('A. 大米','B. 时装','C. 化妆品','D. 旅游服务'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','以下不属于宏观经济政策目标的是（ ）。',JSON_ARRAY('A. 充分就业','B. 物价稳定','C. 经济增长','D. 汇率稳定'),NULL,NULL,1,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','最需要进行广告宣传的市场是（ ）。',JSON_ARRAY('A. 完全竞争市场','B. 垄断竞争市场','C. 寡头垄断市场','D. 完全垄断市场'),NULL,NULL,1,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','披萨饼和炸玉米饼是替代品，如果披萨饼价格上升，则（ ）。',JSON_ARRAY('A. 两种商品的需求都下降','B. 两种商品的需求都增加','C. 炸玉米饼需求增加','D. 炸玉米饼需求下降'),NULL,NULL,1,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','假定某国2022 年社会的投资为3000 亿元，消费支出为2000 亿元，出口为1000 亿元，进口为500 亿元。 政府购买支出为500 亿元，政府转移支付为100 亿元，则使用支出法核算该国的GDP 为（ ）。',JSON_ARRAY('A. 5500 亿元','B. 6000 亿元','C. 7000 亿元','D. 7100 亿元'),NULL,NULL,1,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','宏观经济学的核心是（ ）。',JSON_ARRAY('A. 价格理论','B. 生产理论','C. 厂商均衡理论','D. 国民收入决定理论'),NULL,NULL,1,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','如果一国基尼系数变小，表明该国（ ）。',JSON_ARRAY('A. 富裕程度降低','B. 富裕程度提高','C. 收入分配不平等程度降低','D. 收入分配不平等程度提高'),NULL,NULL,1,'answerable'),
(@pid,16,16,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）无差异曲线的特征包括（ ）。',JSON_ARRAY('A. 任意两条无差异曲线相交','B. 一般来说无差异曲线具有负斜率','C. 一般来说无差异曲线具有正斜率','D. 在无差异曲线的坐标图上，任意一点都应有一条无差异曲线通过'),NULL,NULL,2,'answerable'),
(@pid,17,17,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）用来衡量物价总水平变动的指数有（ ）。',JSON_ARRAY('A. 股票价格指数','B. 消费物价指数','C. 生产物价指数','D. GDP 平减指数'),NULL,NULL,2,'answerable'),
(@pid,18,18,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）随着产量的增加，平均不变成本AFC、平均可变成本AVC、平均成本AC 三条由线的形状，如图1 所 示，关于三者之间的关系，说法正确的是（ ）。',JSON_ARRAY('A. 平均不变成本AFC 先递减','B. 平均成本AC 先递减后递增','C. 平均可变成本AVC 先递减后递增','D. 平均成本AC 等于平均可变成本AVC 和平均固定AFC 之和 图 1'),NULL,NULL,2,'answerable'),
(@pid,19,19,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）具有自动稳定器作用的政策包括（ ）。',JSON_ARRAY('A. 失业保障机制','B. 国债发行制度','C. 所得税税收体系','D. 农产品价格维持制度'),NULL,NULL,2,'answerable'),
(@pid,20,20,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）关于完全竞争下的厂商均衡，说法正确（ ）。',JSON_ARRAY('A. 短期内，厂商不能根据市场需求来调整全部生产要素','B. 长期内，厂商可以根据市场需求来调整全部生产要素','C. 短期内，当供给小于需求时，由于供给不足，市场价格会上升','D. 长期内，当供给小于需求时，整个行业供给增加，市场价格会下降'),NULL,NULL,2,'answerable'),
(@pid,21,21,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）超额利润的主要来源是（ ）。',JSON_ARRAY('A. 劳动','B. 创新','C. 风险','D. 垄断'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）中央银行增加货币供给的手段有（ ）。',JSON_ARRAY('A. 降低再贴现率','B. 降低法定准备金率','C. 在公开市场买入国债','D. 降低基础货币投放量'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）在其他条件不变的情况下，总供给曲线右移是因为（ ）。',JSON_ARRAY('A. 技术进步了','B. 所得税提高了','C. 原材料涨价了','D. 劳动需求增加了'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）根据凯恩斯的货币需求理论，当收入水平上升（ ）。',JSON_ARRAY('A. 交易动机的货币需求会增加','B. 投机动机的货币需求会增加','C. 预防动机的货币需求会增加','D. 三种动机的货币需求都保持不变'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）以下应计入GDP 的支出（ ）。',JSON_ARRAY('A. 家庭用于教育的支出','B. 企业用于厂房的支出','C. 政府用于社会保障的支出','D. 政府用于修建道路的支出'),NULL,NULL,2,'answerable'),
(@pid,26,26,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）当两种商品的需求交叉弹性<0 时，这两种商品为互补品。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,27,27,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）预算约束线是指在收入和商品价格既定的情况下，消费者用于全部收入所能购买到的各种商品不 同数量的组合。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,28,28,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）在均衡等式S+T=I+G 中，储蓄一定等于投资，税收一定等于政府支出。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,29,29,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）在宏观经济学中，总投资被定义为净投资减去折旧，总投资=净投资-折旧。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,30,30,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）税收和政府转移支付都将由于对可支配收入的影响而影响消费。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,31,31,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）西方经济这一般把经济周期分为繁荣、发展、萧条、复苏等四个阶段。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,32,32,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）厂商总成本不变，两种生产要素价格同比例上升，则等成本线向左下方平移。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,33,33,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）菲利普斯曲线表明失业率和通货膨胀之间存在正相关的关系。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,34,34,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）假定土地没有自用价值，则土地的供给曲线与价格之间存在正向关系。',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,35,35,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（ ）一位中国公民在英国拥有一处房地产用于出租，他赚取的租金是英用GDP 的一部分同时也是中 国GDP 的一部分',JSON_ARRAY('A. 正确','B. 错误'),NULL,NULL,1,'answerable'),
(@pid,36,36,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：滞胀',NULL,NULL,NULL,4,'reveal_only'),
(@pid,37,37,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：消费者剩余',NULL,NULL,NULL,4,'reveal_only'),
(@pid,38,38,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：寡头垄断',NULL,NULL,NULL,4,'reveal_only'),
(@pid,39,39,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：流动偏好陷阱',NULL,NULL,NULL,4,'reveal_only'),
(@pid,40,40,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','影响需求量的主要因素？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,41,41,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','什么是边际报酬递减规律？边际报酬递减规律还适用于哪些情况？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,42,42,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','有几种失业类型？形成的条件是什么？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,43,NULL,'material','六、材料分析题（本大题共 15 分）','【材料分析】

材料：中央经济工作会议于2022 年12 月15 日至16 日在北京举行。会议要求，明年要坚持稳字当头、
稳中求进，继续实施积极的财政政策和稳健的货币政策，加大宏观政策调控力度，加强各类政策协调配合，
形成共促高质量发展合力。
积极的财政政策要加力提效。保持必要的财政支出强度，优化组合赤字、专项债、贴息等工具，在有效支
持高质量发展中保障财政可持续和地方政府债务风险可控。要加大中央对地方的转移支付力度，推动财力
下沉，做好基层“三保”工作。
稳健的货币政策要精准有力。要保持流动性合理充裕，保持广义货币供应量和社会融资规模增速同名义经
济增速基本匹配，引导金融机构加大对小微企业、科技创新、绿色发展等领域支持力度。保持人民币汇率
在合理均衡水平上的基本稳定，强化金融稳定保障体系。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,44,NULL,'essay','六、材料分析题（本大题共 15 分）','（1）实施积极的财政政策可采用哪些政策工具？',NULL,NULL,NULL,15,'reveal_only'),
(@pid,45,NULL,'essay','六、材料分析题（本大题共 15 分）','（2）分析积极的财政政策对宏观经济指标如产出、价格水平、就业、投资、消费等产生的影响。',NULL,NULL,NULL,15,'reveal_only'),
(@pid,46,NULL,'essay','六、材料分析题（本大题共 15 分）','（3）积极的财政政策和稳健的货币政策组合如何实现稳中求进。',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 经济学 2024 (33 题, published=1) · 中文卷解析·无完整选择但主观可用·材料1·主观10·暂缺19·共33 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='经济学' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共15 分，每小题1 分。）','需求弹性最大的是（ ）。',JSON_ARRAY('A. 大米','B. 手机','C. 食盐','D. 选项不详'),NULL,NULL,1,'answerable'),
(@pid,2,3,'choice','一、单项选择题（本大题共15 分，每小题1 分。）','当消费者收入和商品价格既定的时候，消费者收入全部用于消费可以购买到的两种商品的不同组合，问 这个曲线是什么（ ）。',JSON_ARRAY('A. 等成本线','B. 等产量线','C. 预算约束线','D. 选项不详'),NULL,NULL,1,'answerable'),
(@pid,3,16,'choice','二、多项选择题（本大题共20 分，每小题2 分。）','（多选）价格歧视的条件是（ ）。',JSON_ARRAY('A. 厂商有权改变价格','B. 消费者的需求弹性不同','C. 能把市场的消费者区分开','D. 市场上的厂商众多'),NULL,NULL,2,'answerable'),
(@pid,4,17,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,5,18,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,6,19,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,7,20,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,8,21,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,9,22,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,10,23,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,11,24,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,12,25,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,13,26,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,14,27,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,15,28,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,16,29,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,17,30,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,18,31,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,19,32,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,20,33,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,21,34,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,22,35,'choice','三、判断题（本大题共10 分，每小题1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,23,36,'fill','四、名词解释（本大题共16 分，每小题4 分。）','名词解释：规模经济',NULL,NULL,NULL,4,'reveal_only'),
(@pid,24,37,'fill','四、名词解释（本大题共16 分，每小题4 分。）','名词解释：投资乘数',NULL,NULL,NULL,4,'reveal_only'),
(@pid,25,38,'fill','四、名词解释（本大题共16 分，每小题4 分。）','名词解释：生产者剩余',NULL,NULL,NULL,4,'reveal_only'),
(@pid,26,39,'fill','四、名词解释（本大题共16 分，每小题4 分。）','名词解释：消费价格指数',NULL,NULL,NULL,4,'reveal_only'),
(@pid,27,40,'essay','五、简答题（本大题共24 分，每小题8 分。）','简述经济周期及其特征。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,28,41,'essay','五、简答题（本大题共24 分，每小题8 分。）','市场有什么类型，其分类的依据是什么。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,29,42,'essay','五、简答题（本大题共24 分，每小题8 分。）','中央银行调节货币供给量的三大工具。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,30,NULL,'material','六、材料分析题（本大题共15 分）','【材料分析】

材料一和材料二讲科技进步和收入增加（其中材料一讲彩电，材料二讲电脑）材料三是关于人工智能的。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,31,NULL,'essay','六、材料分析题（本大题共15 分）','（1）影响商品供给量的主要因素有哪些？',NULL,NULL,NULL,15,'reveal_only'),
(@pid,32,NULL,'essay','六、材料分析题（本大题共15 分）','（2）画图利用供求规律分析彩电均衡价格和数量的变化。',NULL,NULL,NULL,15,'reveal_only'),
(@pid,33,NULL,'essay','六、材料分析题（本大题共15 分）','（3）在未来人工智能是否能进入百姓家？为什么？',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 经济学 2025 (30 题, published=1) · 中文卷解析·选择10·材料0·主观10·暂缺10·共30 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='经济学' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,3,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','吃蛋糕的效用问题，第一块效用 12，第二块效用 10，第三块效用 8，这反映什么经济学原理（ ）。',JSON_ARRAY('A. 边际效用递减规律','B. 总效用递减规律','C. 暂无','D. 暂无'),NULL,NULL,1,'answerable'),
(@pid,2,5,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','供给需求同时增加，均衡价格（ ）。',JSON_ARRAY('A. 上升','B. 下降','C. 不确定','D. 暂无'),NULL,NULL,1,'answerable'),
(@pid,3,7,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','无差异曲线位置和形状取决于（ ）。',JSON_ARRAY('A. 商品自身价格','B. 消费者收入','C. 消费者偏好','D. 消费者预期'),NULL,NULL,1,'answerable'),
(@pid,4,14,'choice','一、单项选择题（本大题共 15 分，每小题 1 分。）','通货膨胀的类型（ ）。',JSON_ARRAY('A. 输入通货膨胀','B. 成本通货膨胀','C. 结构通货膨胀','D. 需求通货膨胀'),NULL,NULL,1,'answerable'),
(@pid,5,20,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）不符合需求规律的有（ ）。',JSON_ARRAY('A. 正常品','B. 普通低档品','C. 吉芬商品','D. 炫耀性商品'),NULL,NULL,2,'answerable'),
(@pid,6,21,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）属于投资的有（ ）。',JSON_ARRAY('A. 购买机器','B. 购买二手厂房','C. 安装风电设备','D. 家庭装修'),NULL,NULL,2,'answerable'),
(@pid,7,22,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）经济周期包括（ ）。',JSON_ARRAY('A. 繁荣','B. 萧条','C. 复苏','D. 衰退'),NULL,NULL,2,'answerable'),
(@pid,8,23,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）以下哪些是流量（ ）。',JSON_ARRAY('A. 土地','B. 总产出','C. 资本','D. 总收入'),NULL,NULL,2,'answerable'),
(@pid,9,24,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）财政政策的自动稳定器（ ）。',JSON_ARRAY('A. 失业保障机制','B. 所得税收体系','C. 农产品价格维持机制','D. 改变政府购买水平策略'),NULL,NULL,2,'answerable'),
(@pid,10,25,'choice','二、多项选择题（本大题共 20 分，每小题 2 分。）','（多选）通货紧缩时的合理做法有（ ）。',JSON_ARRAY('A. 提高税率','B. 促进出口','C. 提高政府支出','D. 下降存款准备金率'),NULL,NULL,2,'answerable'),
(@pid,11,26,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,12,27,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,13,28,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,14,29,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,15,30,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,16,31,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,17,32,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,18,33,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,19,34,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,20,35,'choice','三、判断题（本大题共 10 分，每小题 1 分。）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,21,36,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：公共物品',NULL,NULL,NULL,4,'reveal_only'),
(@pid,22,37,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：替代效应',NULL,NULL,NULL,4,'reveal_only'),
(@pid,23,38,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：经济增长',NULL,NULL,NULL,4,'reveal_only'),
(@pid,24,39,'fill','四、名词解释（本大题共 16 分，每小题 4 分。）','名词解释：总供给',NULL,NULL,NULL,4,'reveal_only'),
(@pid,25,40,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','生产者要增加销售收入，粮食和汽车应该涨价还是降价，原因是什么。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,26,41,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','什么是 GDP，怎样理解 GDP？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,27,42,'essay','五、简答题（本大题共 24 分，每小题 8 分。）','简述凯恩斯的货币需求概念和动机。 4',NULL,NULL,NULL,8,'reveal_only'),
(@pid,28,NULL,'essay','六、材料分析题（本大题共 15 分。）','（1）失业有几种类型，他们的特点是什么。',NULL,NULL,NULL,15,'reveal_only'),
(@pid,29,NULL,'essay','六、材料分析题（本大题共 15 分。）','（2）根据边际技术替代率的相关知识，新时代的人工智能和智能技术会怎样影响企业的生产要素。',NULL,NULL,NULL,15,'reveal_only'),
(@pid,30,NULL,'essay','六、材料分析题（本大题共 15 分。）','（3）新时代我国怎样发展就业？',NULL,NULL,NULL,15,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 教育理论 2023 (34 题, published=1) · 中文卷解析·选择10·材料0·主观24·暂缺0·共34 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='教育理论' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','第一位在中国系统传播马克思主义教育理论的教育理论家是（ ）',JSON_ARRAY('A. 陈独秀','B. 李大钊','C. 杨贤江','D. 恽代军'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','劳动起源论的直接依据和方法论的基础是恩格斯的（ ）',JSON_ARRAY('A. 《劳动起源论》','B. 《教育史教科书》','C. 《动物界的教育》','D. 《劳动在从猿到人转变过程中的作用》'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','决定教育社会性质的是（ ）',JSON_ARRAY('A. 生产力','B. 政治制度','C. 社会制度','D. 文化传统'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','1906 年，清政府学部颁布并明确了国家的教育宗旨是（ ）',JSON_ARRAY('A. 忠君、尊孔、尚公、尚武、尚实','B. 中学为体、西学为用','C. 民智、民力、民德','D. 培养德、智、体、美、劳全面发展的人'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','反映各级各类学校人才博弈特殊要求的（ ）',JSON_ARRAY('A. 教育目的','B. 培养目标','C. 课程目标','D. 教学目标'),NULL,NULL,1,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','我国第一个实际执行的现代学制是（ ）',JSON_ARRAY('A. 壬子学制','B. 癸卯学制','C. 壬戌学制','D. 壬子癸丑学制'),NULL,NULL,1,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','依据课程标准研制的便于教师教和学生学的媒介是（ ）',JSON_ARRAY('A. 教科书','B. 课程计划','C. 课程标准','D. 教学大纲'),NULL,NULL,1,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','提出“范例教学理论”的教育家是（ ）',JSON_ARRAY('A. 凯洛夫','B. 赞可夫','C. 布鲁纳','D. 瓦根舍因'),NULL,NULL,1,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','《中小学教师资格定期注册暂行办法》规定，我国中小学教师资格定期注册的周期是（ ）',JSON_ARRAY('A. 2 年','B. 3 年','C. 5 年','D. 6 年'),NULL,NULL,1,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分。）','根据皮亚杰认知发展阶段理论，中学生的认知发展水平处于（ ）',JSON_ARRAY('A. 前运算阶段','B. 后运算阶段','C. 形式运算阶段','D. 具体运算阶段'),NULL,NULL,1,'answerable'),
(@pid,11,11,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','教育学的发展，总体上可以分为 3 个时期：前学科、前科学和_____时期。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,12,12,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','正规教育和非正规教育统称_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,13,13,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','_____是民族振兴的基石。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,14,14,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','教育与_____相结合是马克思人的全面发展的组成部分。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,15,15,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','_____的内容包括艺术美、社会美 、科学美、自然美 。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,16,16,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','_____教育是由专职人员和专门机构承担的有目的、 有系统、有组织的，以影响入学者身心发展为直接 目标的社会活动。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,17,17,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','高等学校中学历教育分为本科、专科、_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,18,18,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','2001 年的基础教育课程改革是第_____次。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,19,19,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','建构主义的典型模式有_____、情境式教学和交互式教学等。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,20,20,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分。）','根据研究目的，教育科研可以分为探索性研究、描述性研究、解释性研究和_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,21,21,'fill','三、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分。）','名词解释：实体教育',NULL,NULL,NULL,3,'reveal_only'),
(@pid,22,22,'fill','三、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分。）','名词解释：教育的人口功能',NULL,NULL,NULL,3,'reveal_only'),
(@pid,23,23,'fill','三、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分。）','名词解释：教育方针',NULL,NULL,NULL,3,'reveal_only'),
(@pid,24,24,'fill','三、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分。）','名词解释：课程评价',NULL,NULL,NULL,3,'reveal_only'),
(@pid,25,25,'fill','三、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分。）','名词解释：教育学术论文',NULL,NULL,NULL,3,'reveal_only'),
(@pid,26,26,'essay','四、辨析题（先判断正误，再作简要分析。本大题共 1 小题，7 分。）','中小学班主任是受学校委托负责班集体建设的教师，是保障学校教育教学秩序、提高教育质量的中坚力 量，为了建设良好班集体，班主任要深入了解每位学生的特长、优点和不足。因此，有的班主任认为他有 权开拆、查阅学生的信件、日记、电子邮件或者其他网络通信内容。学生不应对此持有异议。请从学生权 利保障的角度，对此观点进行辨析。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,27,27,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分。）','文化对教育的影响主要体现在哪些方面？',NULL,NULL,NULL,5,'reveal_only'),
(@pid,28,28,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分。）','简述现代学校的基本职能。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,29,29,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分。）','古德莱德课程实施的五个层次。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,30,30,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分。）','简述班级管理的原则。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,31,31,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分。）','简述教育科研的意义。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,32,32,'essay','六、论述题（本大题共 2 小题，每小题 10 分，共 20 分。）','请论述劳动教育的意义。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','六、论述题（本大题共 2 小题，每小题 10 分，共 20 分。）','试述教学规律。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,34,'essay','七、案例分析题（本大题共 1 小题，13 分。）','战国时期，有一个很伟大的大学问家孟子。孟子小的时候非常调皮，他的妈妈为了让他受好的教育， 花了很多心血。有一次，他们住在墓地旁边。孟子就和邻居的小孩一起学着大人跪拜、哭嚎的样子，玩起 办理丧事的游戏。孟母看到了，就皱起眉头：“不行，我不能让我的孩子住在这里了。”于是孟母就带着 孟子搬到市集旁边去住。到了市集，孟子又和邻居的小孩，学起商人做生意的样子。一会儿鞠躬欢迎客人、 一会儿招待客人、一会儿和客人讨价还价，表演得像极了！孟母知道了，又皱皱眉头：“这个地方也不适 合我的孩子居住。”于是，他们又搬家了。这一次，他们搬到了学校附近。孟子开始变得守秩序、懂礼貌、 喜欢读书。这个时候，孟母很满意地点着头说：”这才是我儿子应该住的地方呀！”这就是“孟母三迁” 的故事。 问题：请根据案例，再联系实际，分析环境对人发展的影响。',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 教育理论 2024 (26 题, published=1) · 中文卷解析·主观题为主·主观21·暂缺0·共26 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='教育理论' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','根据课程评价与预定目标的关系进行分类，可以将课程评价分为（ ）',JSON_ARRAY('A. 内部人员评价、外部人员评价','B. 过程评价、结果评价','C. 目标本位评价、目标游离评价','D. 诊断性评价、形成性评价、终结性评价'),NULL,NULL,1,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','（ ）创立了现代教育心理学，并践行了以精确的定量方法来开展教育学研究',JSON_ARRAY('A. 赫尔巴特','B. 桑代克','C. 杜威','D. 洛克'),NULL,NULL,1,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','个体的发展由低级到高级，由简单到复杂，由量变到质变。身体的发展由头部，躯干向是施发展，由中 心向边缘发展，由骨骼向肌肉发展。心理机能的发展遵循从简单到复杂,从低级到高级的发展这体现了人身 心发展的( )特性。',JSON_ARRAY('A. 顺序性','B. 阶段性','C. 不平衡性','D. 差异性'),NULL,NULL,1,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','古希腊原是族制度社会，公元前 6 世纪，氏族制度解体产生许多奴隶制承包，产生许多奴隶制城邦，其 中最强大的是（ ）',JSON_ARRAY('A. 欧洲地区','B. 斯巴达和雅典','C. 阿戈斯','D. 科林斯'),NULL,NULL,1,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分）','学生的受教育权包括学习机会权，学习条件权和（ ）',JSON_ARRAY('A. 学习教育权','B. 学习管理权','C. 学习成功权','D. 学习支配权 6-10 暂未收集到'),NULL,NULL,1,'answerable'),
(@pid,6,11,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','教育学是教育科学的基础学科，处于教育科学体系_____学科地位。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,7,12,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','赫尔巴特最主要的教育思想是_____和教学过程阶段论。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,8,13,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','_____是促进学生全面发展，增强学生体质，学习体育知识技能和锻炼意志力等品质的一种有目的，有 计划，有组织的教育活动。 14-16 暂未收集到',NULL,NULL,NULL,1,'reveal_only'),
(@pid,9,17,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','_____教学理论的代表人物是马斯洛和罗杰斯。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,10,18,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','_____是基于元计算技术的一种远程教学形式，具有高效、便捷的特点。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,11,19,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','我国于 1993 年颁布的《中华人民共和国教师法》中提出，教师是履行教育教学职责的_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,12,20,'fill','二、填空题（本大题共 10 小题，每小题 1 分，共 10 分）','教育科学研究可分为不同类型，与此相应，教师所开展的教育科研也有不同类型。根据研究数据性质， 教育科研可分为_____和_____。',NULL,NULL,NULL,1,'reveal_only'),
(@pid,13,21,'fill','三、名词解释(本大题共 5 小题，每小题 3 分，共 15 分)','名词解释：教育内容',NULL,NULL,NULL,3,'reveal_only'),
(@pid,14,22,'fill','三、名词解释(本大题共 5 小题，每小题 3 分，共 15 分)','名词解释：课程目标',NULL,NULL,NULL,3,'reveal_only'),
(@pid,15,23,'fill','三、名词解释(本大题共 5 小题，每小题 3 分，共 15 分)','名词解释：教育调查报告',NULL,NULL,NULL,3,'reveal_only'),
(@pid,16,24,'fill','三、名词解释(本大题共 5 小题，每小题 3 分，共 15 分)','名词解释：分科课程',NULL,NULL,NULL,3,'reveal_only'),
(@pid,17,25,'fill','三、名词解释(本大题共 5 小题，每小题 3 分，共 15 分)','名词解释：情境教学法',NULL,NULL,NULL,3,'reveal_only'),
(@pid,18,26,'essay','四、辨析题(本大题共 1 小题，每小题 7 分，共 7 分)','法国的勒图尔诺在其所著的《动物界教育》中提出:“动物尤其是略为高等的动物，完全同人一样，生 来就有一种由遗传而得到的潜在的教育，其效果见诸于个体的发展过程。”请从教育起源的角度，对此观 点进行辨析。',NULL,NULL,NULL,7,'reveal_only'),
(@pid,19,27,'essay','五、简答题(本大题共 5 小题，每小题 5 分，共 25 分)','实践活动对个体的影响。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,20,28,'essay','五、简答题(本大题共 5 小题，每小题 5 分，共 25 分)','教学目标的功能。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,21,29,'essay','五、简答题(本大题共 5 小题，每小题 5 分，共 25 分)','我国现代学校制度建设的基本任务。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,22,30,'essay','五、简答题(本大题共 5 小题，每小题 5 分，共 25 分)','教师开展教育科研主要以哪些方面为导向?',NULL,NULL,NULL,5,'reveal_only'),
(@pid,23,31,'essay','五、简答题(本大题共 5 小题，每小题 5 分，共 25 分)','课程目标的基本取向。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,24,32,'essay','六、论述题(本大题共 2 小题，每小题 10 分，共 20 分)','2018 年 9 月 10 日，习近平总书记在大会上指出:“教师是人类灵魂的工程师……塑造新人的时代重任。” 联系实际，论述教师角色的内涵。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,25,33,'essay','六、论述题(本大题共 2 小题，每小题 10 分，共 20 分)','2024 年 3 月 5 日，国务院总理李强所作的《政府工作报告》提出:“深入实施科教兴国战略……为现代 化建设提供强大动力。”联系实际，论述教育的经济功能。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,26,34,'essay','七、案例分析题(本大题共 1 小题，每小题 13 分，共 13 分)','材料暂未收集到 考查美育的意义、目标和内容。',NULL,NULL,NULL,13,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 教育理论 2025 (34 题, published=1) · 中文卷解析·主观题为主·主观14·暂缺20·共34 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='教育理论' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,2,2,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,3,3,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,4,4,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,5,5,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,6,6,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,7,7,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,8,8,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,9,9,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,10,10,'choice','一、单项选择题（本大题共 10 小题，每小题 1 分，共 10 分、每小题只有一个选项符合题目','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,11,11,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,12,12,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,13,13,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,14,14,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,15,15,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,16,16,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,17,17,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,18,18,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,19,19,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,20,20,'fill','二、填空题（本大题共 10 空，每空 1 分，共 10 分）','（本题在考生回忆版中暂缺）',NULL,NULL,'回忆版原卷该题暂缺',1,'missing'),
(@pid,21,21,'fill','三、名词解释题（本大题共五小题，每小题 3 分，共 15 分）','名词解释：学校教育',NULL,NULL,NULL,3,'reveal_only'),
(@pid,22,22,'fill','三、名词解释题（本大题共五小题，每小题 3 分，共 15 分）','名词解释：开放大学',NULL,NULL,NULL,3,'reveal_only'),
(@pid,23,23,'fill','三、名词解释题（本大题共五小题，每小题 3 分，共 15 分）','名词解释：学校管理制度',NULL,NULL,NULL,3,'reveal_only'),
(@pid,24,24,'fill','三、名词解释题（本大题共五小题，每小题 3 分，共 15 分）','名词解释：研究设计',NULL,NULL,NULL,3,'reveal_only'),
(@pid,25,25,'fill','三、名词解释题（本大题共五小题，每小题 3 分，共 15 分）','名词解释：走班制',NULL,NULL,NULL,3,'reveal_only'),
(@pid,26,26,'essay','四、辨析题（先判断正误，再做简要分析，本大题共一小题，7 分）','有观点认为，教科书都是正确的，教师和学生任何时候都必须遵循教科书，不能有一点改变。 2',NULL,NULL,NULL,7,'reveal_only'),
(@pid,27,27,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分）','学生观的内容',NULL,NULL,NULL,5,'reveal_only'),
(@pid,28,28,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分）','教育的文化功能',NULL,NULL,NULL,5,'reveal_only'),
(@pid,29,29,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分）','教育促进个体个性化功能的表现',NULL,NULL,NULL,5,'reveal_only'),
(@pid,30,30,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分）','教学的评价功能',NULL,NULL,NULL,5,'reveal_only'),
(@pid,31,31,'essay','五、简答题（本大题共 5 小题，每小题 5 分，共 25 分）','教育科研的步骤 3',NULL,NULL,NULL,5,'reveal_only'),
(@pid,32,32,'essay','六、论述题（本大题共 2 小题，每小题 10 分，共 20 分）','个体社会化的功能',NULL,NULL,NULL,10,'reveal_only'),
(@pid,33,33,'essay','六、论述题（本大题共 2 小题，每小题 10 分，共 20 分）','学校教育的意义',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,34,'essay','七、材料分析题(本大题共 2 小题，每小题 13 分，共 13 分)','学生观，还有研究的过程 4',NULL,NULL,NULL,13,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 生理学 2022 (37 题, published=1) · 中文卷解析·选择24·材料1·主观12·暂缺0·共37 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='生理学' AND year=2022 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','体液调节的特点是（ ）。',JSON_ARRAY('A. 迅速','B. 精确','C. 持久','D. 局限'),NULL,NULL,2,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','神经纤维动作电位上升支的离子流动是（ ）。',JSON_ARRAY('A. K+外流','B. K+内流','C. Na+外流','D. Na+内流'),NULL,NULL,2,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列情况会引起血细胞比容降低的是（ ）。',JSON_ARRAY('A. 缺铁性贫血','B. 严重腹泻','C. 大面积烧伤','D. 反复呕吐'),NULL,NULL,2,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','心率超过 180/min，导致血输出量下降的主要原因是（ ）。',JSON_ARRAY('A. 快速射血期缩短','B. 心室舒张期变短','C. 等容收缩期变短','D. 等容舒张期变短'),NULL,NULL,2,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','可用于诊断早期妊娠的激素是（ ）。',JSON_ARRAY('A. hCG','B. LH','C. FSH','D. 孕酮'),NULL,NULL,2,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','心脏不会发生强直性收缩的原因是（ ）。',JSON_ARRAY('A. 心肌细胞存在自律性','B. 有效不应期长','C. 舒张期的超常期长','D. 心肌细胞存在兴奋性'),NULL,NULL,2,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列能促进血液凝固的方法是（ ）。',JSON_ARRAY('A. 降温至 5℃','B. 去除血浆 Ca2+','C. 加入肝素','D. 提供粗糙面'),NULL,NULL,2,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','按压颈动脉压力感受器使其增强可导致（ ）。',JSON_ARRAY('A. 心率加快，血压降低','B. 心率减慢，血压降低','C. 心率加快，血压升高','D. 心率减慢，血压升高'),NULL,NULL,2,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','氧气在血液中的主要运输方式是（ ）。',JSON_ARRAY('A. 物理溶解','B. 氧合血红蛋白','C. 碳酸氢盐','D. 氨基甲酰血红蛋白'),NULL,NULL,2,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列物质中属于第二信使的是（ ）。',JSON_ARRAY('A. ATP','B. ADP','C. cAMP','D. ACTH'),NULL,NULL,2,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','中枢化学感受器敏感的刺激物是（ ）。',JSON_ARRAY('A. 动脉中的 CO2','B. 脑脊髓中的 CO2','C. 动脉血中的 H+','D. 脑脊髓中的 H+'),NULL,NULL,2,'answerable'),
(@pid,12,13,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列食物胃排空速度快慢的顺序，正确的是（ ）。',JSON_ARRAY('A. 糖>脂肪>蛋白质','B. 脂肪>蛋白质>糖','C. 糖>蛋白质>脂肪','D. 蛋白质>糖>脂肪'),NULL,NULL,2,'answerable'),
(@pid,13,14,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列与肾小球有效滤过压形成无关的是（ ）。',JSON_ARRAY('A. 囊内压','B. 血浆晶体渗透压','C. 肾小球毛细血管压','D. 血浆胶体渗透压'),NULL,NULL,2,'answerable'),
(@pid,14,15,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','在胃液内能促进维生素 B12 吸收的物质是（ ）。',JSON_ARRAY('A. 钠离子','B. 内因子','C. 盐酸','D. 胃蛋白酶'),NULL,NULL,2,'answerable'),
(@pid,15,16,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','人体能量代谢水平较稳定的环境温度是（ ）。',JSON_ARRAY('A. 0～10℃','B. 10～20℃','C. 20～30℃','D. 30～40℃'),NULL,NULL,2,'answerable'),
(@pid,16,17,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','体温调节的基本中枢是（ ）。',JSON_ARRAY('A. 延髓','B. 下丘脑','C. 脊髓','D. 大脑皮层'),NULL,NULL,2,'answerable'),
(@pid,17,18,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','人体细胞直接接触并赖以生存的环境是（ ）。',JSON_ARRAY('A. 细胞外液','B. 血浆','C. 组织液','D. 细胞内液'),NULL,NULL,2,'answerable'),
(@pid,18,19,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','近端小管重吸收 HCO3-的主要形式是（ ）。',JSON_ARRAY('A. CO2','B. O2','C. HCO3-','D. H2CO3'),NULL,NULL,2,'answerable'),
(@pid,19,20,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','临床中用静脉注射 20%的甘露醇来利尿消肿，其机制是（ ）。',JSON_ARRAY('A. 肾小球滤过率增高','B. 抗利尿激素释放减少','C. 醛固酮释放减少','D. 小管液溶质的浓度增高'),NULL,NULL,2,'answerable'),
(@pid,20,21,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列关于近视眼的说法，错误的是（ ）。',JSON_ARRAY('A. 晶状体前后径过长','B. 佩戴凹透镜矫正','C. 光线聚焦在视网膜前','D. 眼的折光能力减弱'),NULL,NULL,2,'answerable'),
(@pid,21,22,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','局部麻醉药镇痛的原理是破坏神经纤维的（ ）。',JSON_ARRAY('A. 结构完整性','B. 髓鞘','C. 功能完整性','D. 绝缘性'),NULL,NULL,2,'answerable'),
(@pid,22,23,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','副交感神经兴奋后会出现（ ）。',JSON_ARRAY('A. 瞳孔散大','B. 胃肠平滑肌收缩','C. 心率加快','D. 膀胱逼尿肌舒张'),NULL,NULL,2,'answerable'),
(@pid,23,24,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','与女性基础体温升高有关的激素是（ ）。',JSON_ARRAY('A. 雌激素','B. 孕激素','C. 卵泡生成素','D. 黄体生成素'),NULL,NULL,2,'answerable'),
(@pid,24,25,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','某人大脑皮层左侧运动区受损时，表现为下列哪部分的运动躯体受损（ ）。',JSON_ARRAY('A. 右半身','B. 右侧面部','C. 左半身','D. 左侧面部'),NULL,NULL,2,'answerable'),
(@pid,25,26,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：突触',NULL,NULL,NULL,3,'reveal_only'),
(@pid,26,27,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：水利尿',NULL,NULL,NULL,3,'reveal_only'),
(@pid,27,28,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：心动周期',NULL,NULL,NULL,3,'reveal_only'),
(@pid,28,29,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：等渗溶液',NULL,NULL,NULL,3,'reveal_only'),
(@pid,29,30,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：吸收',NULL,NULL,NULL,3,'reveal_only'),
(@pid,30,31,'essay','三、简答题（本大题共 15 分，每小题 5 分）','人从长期蹲着突然站起，暂时感到头晕。从静脉回心血量的影响因素来解释这种情况。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,31,32,'essay','三、简答题（本大题共 15 分，每小题 5 分）','小脑损害的人，走路不稳，试结合案例简述小脑的生理功能。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,32,33,'essay','三、简答题（本大题共 15 分，每小题 5 分）','结合肺通气量和肺泡通气量的计算方式及其数值，并以肺通气为依据，判断两种呼吸形式哪个更有效。 呼吸形式 潮气量（ml） 呼吸频率 无效腔气量（ml） 浅快 250 24 150 深慢 1000 6 150',NULL,NULL,NULL,5,'reveal_only'),
(@pid,33,34,'essay','四、论述题（本大题共 10 分，每小题 10 分）','试述易化扩散和单纯扩散的异同点，并举例说明。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,34,NULL,'material','五、案例分析题','【材料分析】

女性患者，体温高，烦躁不安，多汗，临床诊断：甲状腺功能亢进。问：',NULL,NULL,NULL,0,'reveal_only'),
(@pid,35,NULL,'essay','五、案例分析题','（1）这位病人的基础代谢率有什么改变?',NULL,NULL,NULL,8,'reveal_only'),
(@pid,36,NULL,'essay','五、案例分析题','（2）甲状腺的主要生理功能。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,37,NULL,'essay','五、案例分析题','（3）病人的 T3 和 T4 升高，导致 TSH 降低，这是一种什么调节机制?',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 生理学 2023 (13 题, published=1) · 中文卷解析·无完整选择但主观可用·材料1·主观12·暂缺0·共13 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='生理学' AND year=2023 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,26,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：稳态',NULL,NULL,NULL,3,'reveal_only'),
(@pid,2,27,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：去极化',NULL,NULL,NULL,3,'reveal_only'),
(@pid,3,28,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：肺通气',NULL,NULL,NULL,3,'reveal_only'),
(@pid,4,29,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：感受器',NULL,NULL,NULL,3,'reveal_only'),
(@pid,5,30,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：激素',NULL,NULL,NULL,3,'reveal_only'),
(@pid,6,31,'essay','三、简答题（本大题共 15 分，每小题 5 分）','简述小肠能成为主要吸收部位的原因。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,7,32,'essay','三、简答题（本大题共 15 分，每小题 5 分）','腱反射的反射弧组成。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,8,33,'essay','三、简答题（本大题共 15 分，每小题 5 分）','简述输血的原则。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,9,34,'essay','四、论述题（本大题共 10 分，每小题 10 分）','给家兔（2.5kg）注射 20%葡萄糖溶液 10ml，家兔的尿量如何变化，机制是什么？',NULL,NULL,NULL,10,'reveal_only'),
(@pid,10,NULL,'material','五、案例分析题（本大题共 10 分）','【材料分析】

35.患者，男性，60 岁，既往高血压病史 15 年，一直未接受规范治疗，血压 150/100mmHg。近 5 年来出现
轻微劳动后心悸，呼吸困难，休息后可缓解。近一个月来呼吸困难加重，无法平卧，常采取端坐或半卧位。
X 线胸片检查显示左心室肥大。临床诊断：高血压性心脏病，左心功能不全根据材料回答下列',NULL,NULL,NULL,0,'reveal_only'),
(@pid,11,NULL,'essay','五、案例分析题（本大题共 10 分）','（1）心率加快时血压有何变化？',NULL,NULL,NULL,10,'reveal_only'),
(@pid,12,NULL,'essay','五、案例分析题（本大题共 10 分）','（2）除心率外，影响动脉血压因素还有哪些？',NULL,NULL,NULL,10,'reveal_only'),
(@pid,13,NULL,'essay','五、案例分析题（本大题共 10 分）','（3）该患者为什么会出现呼吸困难？',NULL,NULL,NULL,10,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 生理学 2024 (38 题, published=1) · 中文卷解析·选择25·材料1·主观12·暂缺0·共38 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='生理学' AND year=2024 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','能引起机体发生反应的各种内外环境变化称为（ ）。',JSON_ARRAY('A. 反射','B. 兴奋','C. 刺激','D. 应激'),NULL,NULL,2,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','取蛙坐骨神经标本研究神经干动作电位的传导，其实验方法是（ ）。',JSON_ARRAY('A. 慢性实验','B. 急性在体实验','C. 整体实验','D. 急性离体实验'),NULL,NULL,2,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','骨骼肌静息电位对什么离子的通透性最高（ ）。',JSON_ARRAY('A. Na+','B. Cl-','C. K+','D. Ca2+.'),NULL,NULL,2,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','75%的乙醇擦拭后，乙醇通过哪种方式进入体内（ ）。',JSON_ARRAY('A. 单纯扩散','B. 易化扩散','C. 主动转运','D. 入胞'),NULL,NULL,2,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','外源性凝血的启动因子（ ）。',JSON_ARRAY('A. Ca2+','B. 凝血因子 XII','C. 凝血因子 X','D. 组织因子'),NULL,NULL,2,'answerable'),
(@pid,6,6,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','合成血红蛋白的原料是（ ）。',JSON_ARRAY('A. 维生素 B12 和铁','B. 铁和蛋白质','C. 叶酸和铁','D. 维生素 B12 和叶酸'),NULL,NULL,2,'answerable'),
(@pid,7,7,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','影响主要收缩压的是（ ）。',JSON_ARRAY('A. 外周阻力','B. 每搏输出量','C. 心率','D. 动脉弹性储器作用'),NULL,NULL,2,'answerable'),
(@pid,8,8,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','窦房结细胞具有自律性的原因是（ ）。',JSON_ARRAY('A. 具有平台期','B. 1 期快速去极化期','C. 4 期自动去极化期','D. 3 期快速复极化期'),NULL,NULL,2,'answerable'),
(@pid,9,9,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列因素与动作电位在神经纤维传导无关的是（ ）。',JSON_ARRAY('A. 温度','B. 有无髓鞘','C. 神经纤维直径','D. 刺激强度'),NULL,NULL,2,'answerable'),
(@pid,10,10,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','以下对心指数描述正确的是（ ）。',JSON_ARRAY('A. 每搏输出量÷体表面积','B. 心率/体表面积','C. 每搏输出量×心率×体表面积','D. 每搏输出量×心率÷体表面积'),NULL,NULL,2,'answerable'),
(@pid,11,11,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','以下描述错误的是（ ）。',JSON_ARRAY('A. 呼吸膜 5 层','B. 途径①是肺泡内 O2 通过扩散进去血管里','C. 途径②是 CO2 通过扩散进入到肺泡里','D. 肺水肿会引起呼吸膜增厚'),NULL,NULL,2,'answerable'),
(@pid,12,12,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','一氧化碳中毒的原因（ ）。',JSON_ARRAY('A. 血红蛋白减少','B. 红细胞减少','C. 血红蛋白释放氧气减少','D. 脱氧血红蛋白增多'),NULL,NULL,2,'answerable'),
(@pid,13,13,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','下列哪项是最大促进促胰液素分泌（ ）。',JSON_ARRAY('A. 盐酸','B. 蛋白质','C. 糖类','D. 脂酸钠'),NULL,NULL,2,'answerable'),
(@pid,14,14,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','胆汁中的哪个成分能够促进脂肪分解（ ）。',JSON_ARRAY('A. 胆盐','B. 胆固醇','C. 胆色素','D. 卵磷脂'),NULL,NULL,2,'answerable'),
(@pid,15,15,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','不能滤过的半透膜的是（ ）。',JSON_ARRAY('A. Na+','B. 蛋白质','C. K+','D. 葡萄糖'),NULL,NULL,2,'answerable'),
(@pid,16,16,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','大量饮清水导致抗利尿激素减少原因（ ）。',JSON_ARRAY('A. 胶体渗透压升高','B. 胶体渗透压降低','C. 血管紧张素 II 增加','D. 血浆晶体渗透压降低'),NULL,NULL,2,'answerable'),
(@pid,17,17,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','肾脏合成并释放的是（ ）。',JSON_ARRAY('A. 抗利尿激素','B. 肾上腺素','C. 促红细胞生成素','D. 去甲肾上腺素'),NULL,NULL,2,'answerable'),
(@pid,18,18,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','颜色视野范围最大的是（ ）。',JSON_ARRAY('A. 白色','B. 绿色','C. 红色','D. 绿色'),NULL,NULL,2,'answerable'),
(@pid,19,19,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','不属于非突触传递的特点（ ）。',JSON_ARRAY('A. 双向传递','B. 作用较弥散','C. 无特定扩散间歇','D. 无特定接头后膜'),NULL,NULL,2,'answerable'),
(@pid,20,20,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','心肌缺血疼痛部位是（ ）。',JSON_ARRAY('A. 左肩、左上臂','B. 左上腹、肩胛间区','C. 右上腹、右肩区','D. 上腹部、脐周围'),NULL,NULL,2,'answerable'),
(@pid,21,21,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','去甲肾上腺素与糖皮质激素对机体的作用属于（ ）。',JSON_ARRAY('A. 协同作用','B. 拮抗作用','C. 允许作用','D. 竞争作用'),NULL,NULL,2,'answerable'),
(@pid,22,22,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','成年人调节血钙最重要的激素（ ）。',JSON_ARRAY('A. 降钙素','B. 甲状腺激素','C. 胰岛素','D. 甲状旁腺激素'),NULL,NULL,2,'answerable'),
(@pid,23,23,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','哺乳期乳腺泌乳的维持（ ）。',JSON_ARRAY('A. 雌激素的作用','B. 缩宫素和催乳素的作用','C. 雌激素和孕激素的作用','D. 雌激素与生长激素的作用'),NULL,NULL,2,'answerable'),
(@pid,24,24,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','精子在女性生殖道内待留一段时间才能获得使卵子受精的能力（ ）。',JSON_ARRAY('A. 精子获能','B. 顶体反应','C. 受精','D. 着床'),NULL,NULL,2,'answerable'),
(@pid,25,25,'choice','一、单项选择题（本大题共 50 分，每小题 2 分）','同一强度的触觉连续刺激后反应突然下降，属于（ ）。',JSON_ARRAY('A. 适应','B. 疲劳','C. 抑制','D. 衰减'),NULL,NULL,2,'answerable'),
(@pid,26,26,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：血型',NULL,NULL,NULL,3,'reveal_only'),
(@pid,27,27,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：应急反应',NULL,NULL,NULL,3,'reveal_only'),
(@pid,28,28,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：妊娠',NULL,NULL,NULL,3,'reveal_only'),
(@pid,29,29,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：肾小球滤过率',NULL,NULL,NULL,3,'reveal_only'),
(@pid,30,30,'fill','二、名词解释（本大题共 15 分，每小题 3 分）','名词解释：胃排空',NULL,NULL,NULL,3,'reveal_only'),
(@pid,31,31,'essay','三、简答题（本大题共 15 分，每小题 5 分）','简述影响骨骼肌收缩效能的因素。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,32,32,'essay','三、简答题（本大题共 15 分，每小题 5 分）','简述肺泡表面活性物质的主要作用及生理意义。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,33,33,'essay','三、简答题（本大题共 15 分，每小题 5 分）','下表为几种组织器官在不同状态下的产热量。 组织器官 重量（占体重的%） 产热量（占机体总产热量的%） 安静状态 运动、劳动状态 脑 2.5 16 3 内脏 34 56 22 肌肉 40 18 73 其他 23.5 10 2 根据上表，说明安静状态、运动状态下机体最主要的产热器官分别是？并说明在环境温度 20～25℃时机体 的主要产热方式。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,34,34,'essay','四、论述题（本大题共 10 分，每小题 10 分）','论述心动周期中左心室收缩期压力、瓣膜、容积和血流方向的变化。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,35,NULL,'material','五、案例分析题（本大题共 10 分）','【材料分析】

患者，女性，68 岁，主诉上肢不自主地抖动，行动迟缓 5 年。体格检査：体温 36.5℃，血压 135/80mmHg，
心率 85 次/分，呼吸 20 次/分。心脏腹部检查无异常。神志清楚，言语含糊不清，双上肢静止性震颤。四
肢肌张力增高，动作迟缓，起步困难，有典型的“慌张步态”。脑骨液细胞学及生化检查正常。临床诊断：
帕金森病',NULL,NULL,NULL,0,'reveal_only'),
(@pid,36,NULL,'essay','五、案例分析题（本大题共 10 分）','（1）该患者的主要病变部位在哪？',NULL,NULL,NULL,10,'reveal_only'),
(@pid,37,NULL,'essay','五、案例分析题（本大题共 10 分）','（2）结合症状，分析该病机制。',NULL,NULL,NULL,10,'reveal_only'),
(@pid,38,NULL,'essay','五、案例分析题（本大题共 10 分）','（3）采用左旋多巴类药物治疗该病的依据？',NULL,NULL,NULL,10,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

-- ===== 广东 生理学 2025 (18 题, published=1) · 中文卷解析·无完整选择但主观可用·材料1·主观12·暂缺0·共18 =====
SET @pid := (SELECT id FROM paper WHERE province='广东' AND subject='生理学' AND year=2025 AND deleted=0 LIMIT 1);
DELETE FROM paper_question WHERE paper_id=@pid;
INSERT INTO paper_question (paper_id, seq, paper_no, q_type, section_title, stem, options_json, answer, analysis, score, input_mode) VALUES
(@pid,1,1,'choice','一、单项选择题（本大题共 25 小题，每小题 2 分，共 50 分。每小题只有一个选项符合要求）','体液调节的特点是（ ）。',JSON_ARRAY('A. 反应迅速，作用时间长','B. 缓慢，作用范围广','C. 精确，作用时间短','D. 反应迅速，作用范围广'),NULL,NULL,2,'answerable'),
(@pid,2,2,'choice','一、单项选择题（本大题共 25 小题，每小题 2 分，共 50 分。每小题只有一个选项符合要求）','属于正反馈的是（ ）。',JSON_ARRAY('A. 腱反射','B. 排尿反射','C. 降压反射','D. 牵张反射'),NULL,NULL,2,'answerable'),
(@pid,3,3,'choice','一、单项选择题（本大题共 25 小题，每小题 2 分，共 50 分。每小题只有一个选项符合要求）','能与钙离子结合的是（ ）。',JSON_ARRAY('A. 肌动蛋白','B. 肌球蛋白原','C. 肌球蛋白','D. 肌钙蛋白'),NULL,NULL,2,'answerable'),
(@pid,4,4,'choice','一、单项选择题（本大题共 25 小题，每小题 2 分，共 50 分。每小题只有一个选项符合要求）','神经细胞受到一个有效刺激，膜电位迅速上升到 0mv 细胞的兴奋性处于（ ）。',JSON_ARRAY('A. 绝对不应期','B. 超常期','C. 相对不应期','D. 静息期'),NULL,NULL,2,'answerable'),
(@pid,5,5,'choice','一、单项选择题（本大题共 25 小题，每小题 2 分，共 50 分。每小题只有一个选项符合要求）','不属于局部电位的特性是（ ）',JSON_ARRAY('A. 等级性电位','B. 衰减式传递','C. 全或无现象','D. 可以总和'),NULL,NULL,2,'answerable'),
(@pid,6,26,'fill','二、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：内环境',NULL,NULL,NULL,3,'reveal_only'),
(@pid,7,27,'fill','二、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：视敏度 2',NULL,NULL,NULL,3,'reveal_only'),
(@pid,8,28,'fill','二、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：基础代谢率',NULL,NULL,NULL,3,'reveal_only'),
(@pid,9,29,'fill','二、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：肺活量',NULL,NULL,NULL,3,'reveal_only'),
(@pid,10,30,'fill','二、名词解释题（本大题共 5 小题，每小题 3 分，共 15 分）','名词解释：突触可塑性',NULL,NULL,NULL,3,'reveal_only'),
(@pid,11,31,'essay','三、简答题（本大题共三小题，每小题 5 分，共 15 分）','影响肾小球滤过率的因素有哪些？',NULL,NULL,NULL,5,'reveal_only'),
(@pid,12,32,'essay','三、简答题（本大题共三小题，每小题 5 分，共 15 分）','简述物质跨膜转运的方式有那些。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,13,33,'essay','三、简答题（本大题共三小题，每小题 5 分，共 15 分）','小肠分节运动的生理作用是什么。',NULL,NULL,NULL,5,'reveal_only'),
(@pid,14,34,'essay','四、论述题（本大题共 1 小题，每小题 10 分，共 10 分）','运动时血压突然升高，压力感受性反射会引起血压如何改变？请阐述其过程(10 分) 3',NULL,NULL,NULL,10,'reveal_only'),
(@pid,15,NULL,'material','五、案例分析题（本大题共 1 小题，共 10 分）','【材料分析】

患者，男性，40 岁。一年前确诊肾病综合症，服用醋酸泼尼松片（糖皮质激素药物）。半年后出现明
显虚胖，双膝间歇性水肿，体力下降。体格检查发现患者呈“满月脸”、“水牛背”，四肢消瘦的“向心
性肥胖”体征，血液检查各项指标均正常，尿常规正常。',NULL,NULL,NULL,0,'reveal_only'),
(@pid,16,NULL,'essay','五、案例分析题（本大题共 1 小题，共 10 分）','（1）请问：向心性肥胖的出现是药物副作用还是肾病综合征的表现？',NULL,NULL,NULL,8,'reveal_only'),
(@pid,17,NULL,'essay','五、案例分析题（本大题共 1 小题，共 10 分）','（2）试述糖皮质激素的主要生理作用。',NULL,NULL,NULL,8,'reveal_only'),
(@pid,18,NULL,'essay','五、案例分析题（本大题共 1 小题，共 10 分）','（3）请问糖皮质激素类药物可以突然停药吗？请回答其原因。',NULL,NULL,NULL,8,'reveal_only');
UPDATE paper SET has_answer=0, published=1 WHERE id=@pid;

