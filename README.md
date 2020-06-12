# 需求

    前端：技能图标，
    前端：小地图.jpg/.png
    --选择势力与选择首发的背景图
    前端：按钮排版和按钮图标

# 遇到问题

    ---单骑特效附着点不对
    ---关羽出生有血迹，某技能特效附着点不对
    策划：经验 金币获取
    --冲阵，判断暴击
    新轮刷新状态的自杀，会统计在死亡次数
    --英雄会击杀进攻方的英雄会获得击杀奖励，金币和经验，自己会升级
    英雄单位受到玩家设置影响，准备轮有操作的话不自动攻击
    信使出售装备，武将的装备依旧保留
    主公报空
    重复刷怪

# 后面的工作

    地图上创建单位的接口模块    
    根据表表给的命名规则重写羁绊触发的方法
    击杀事件隐藏
    阵法
    蜀国技能--先生
    蜀国单位--表表
    前端：15 主界面按钮：阵型，宝物，组合，道具，科技升级
    --前端：16 单位技能：招募，驱逐(流放，贩卖)
    逻辑：--18 反抄袭/双语化
    逻辑：10 1人图完成后改灰盒
    断线重连

# 解决问题/完成部分
## 6/8-6/14

    测试方法的技能接口
    获取对战的进攻方清单的接口
    获取对战的防守方清单的接口：搜寻队友的方法
    更新readme，替代workline
    逻辑：出售武将
    调整语句，删除冗余部分
    独立刷怪的包，如果诺诺来了，可以直接上手编写怪物的生产
    玩家技能：不再能对自己使用，战斗回合不可用
    新建扣费方法，预防升级出售可能出现的金钱的数据穿透。禁止透支的bug，
    改写升级方法，解决单位自带等级的冲突
    修复给单位复位的时候卡位的问题
    点将台驱散
    点将台付费升级
    清除了击杀获取经验的问题，使用技能升级不影响
    --金币获取 杀死单位 和 工资，，进攻方防守方均获得--击杀获取部分写在单位的KV里
    解决了工资发放问题
    取消升级获得技能点，改为同步提升全部技能等级
    替换护甲计算公式
    添加了基础属性附加
    测试了5月份表表写的全部技能(发给我一共发给我18个，6个是未找到，9个需要返工，3个数据不对）
    整理魔闪网资料

## 6/1-6/7

    整理魔闪网资料部分
    测试了5月份先生写的全部技能(上个月报了40个技能，发给我40个，22个需返工，10个因图片原因没有不同等级的变量，8个没问题)截至6月7日，返工修复了18个，返工部分尚未测试
    提供了vscode+git的同源方案
    禁止武将装备售卖

## 既往

    同步信使和武将的装备，信使购买装备，武将同步拥有
    重画2人地图，地图尺寸  map2的距离大了
    新添技能：放权，kv+lua+执行脚本，
    --策划：放权：转移30%属性，这个属性具体是的哪些参数,现在单位没有三维
    修正AI写法
    增加玩家施法失败反馈参数
    添加武器 青釭剑，写入商店，指定放置库存位，
    修复：进攻方卡位问题
    --策划：进攻方没有刷新羁绊，因为羁绊是在准备阶段刷新的，他们是在战斗阶段创建的，
    修复：复制出来的进攻方是1级
    逻辑：14 写商店，科技树放商店里
    策划：单位升级与点将台对照
    开局发10个杂兵，每轮再发5个杂兵
    策划：单位放到点将台（0-5）上面后，人口是否归还？
    策划：物品模型选英雄模型会缺少饰品部分
    重写武将定位，武将
    移至 武将台 不占用人口 
    两个物品，物品有指定格子占用
    英雄可以买活
    英雄的技能需要手动学习，升级不是自动提升技能等级
    准备回合刷新所有技能CD
    点将台的升级，--出售
    写一个英雄单位，召唤他
        禁止经验获取，禁止金币获取
        禁止自动复活
        新轮刷新状态
    优化：把倒计时的工作拆分到了5秒内，5：锁防守，4：记录位置，3生进攻，锁进攻，2面向，0全解锁，判断羁绊，刷新羁绊，开战，删栅栏，
    debug：修复了人口参数的调用问题
    逻辑：给单位赋值，令不同的单位消耗人口不同
    debug：新一轮准备阶段打断玩家的控制命令：单位移动
    优化：新的遍历语言,优化了遍历逻辑，更好的性能
    工具：创建指定单位的命令
    工具：拆分测试包和成品包
        对战 限制1分钟，强制结束 
        新轮 刷满篮 
        桃园 移动触发，攻击触发 
    设置新轮时单位朝面方向
    写了一个测试包，组合单位，技能，图标用
    逻辑：写一个商品用来增加人口，
    选择势力与随机四个首发
    点将台基本搭建,随机出十个，排序，招募
    搜将显示搜到的名字发送消息
    武圣的吸血
    写了攻击类型："none","tree","fire","electrical","water","land","god"
    前端：神武将的头像不能被读取，后缀要改为PNG
    技能：链接
    技能：铁骑
    策划：战斗阶段招募的武将无法归位，无法复活
    策划：羁绊：桃园结义在倒计时中刷新，但是触发条件写的是被攻击，KV中无法判断游戏阶段
    bug：计时器UI 会出现没有删除的情况--可能只有本地发生--删掉倒计时进度条，换成中部倒数
    bug：playerOwner 有时候获取不到，导致主公不掉血
    bug：武将台图标不消失，
    修正了刷新羁绊的一个BUG
    逻辑：战斗期间加一个板遮住点将台，这个时候不能买武将--
    逻辑：写一个人口参数，前端展示，创建单位要区分回归和招募,
    21 搜将获得物品限制5个/与装备位置问题
    写一个AI
    从队伍ID到玩家id的获取
    11 选择势力，主公的界面--第一个武将
    5 选完英雄后载入时间过长--可能是d2wt的原因
    9 强制选择信使
    重写购买武将为掉落在地上
    监视物品购买
    12 设置信使出生带技能等级1
    写一个修饰器，准备阶段结束时禁用信使的物品和技能
    22 改变武将售价
    测试新激将
    删掉原有物品，
    19 23轮开始 随机出现一个敌方单位会卡住不继续路径
    死了的单位复活失败
    做对战区域
    记录准备回合的所有单位和位置
    设置了失败和胜利
    7物品只能放入只能格子API没找到，（饰品仅带一件）逻辑1是给同类物品加属性，重复属性无法携带，但是物品栏无法排序。
    逻辑2是放指定格子，API没找到
    13 写箱子，
    准备阶段和对战阶段框架打好
    物品图标，可以用war3的
    已经写的刘备是武将（上场打架的）还是主公（来怪掉血的）。。。
    载入图片，选择队伍时的背景图
    17 主公创建 主公掉血 
    6 魏蜀吴的字段无法调用，目前方案计算量偏大，主公技暂时搁置，
    3 仁德目前以主公为圆心释放，改为AOE会无目标
    2 关了UI， 选择势力的旧UI无法使用，需要重做

    8被动无法出生自带，即使是被动也是需要手动点击升级才有该技能。把武将和杂兵都写成unit,不写hero

### 逻辑：

    主线：  倒计时    stat=0 回合数+1
                            修长城
                            删信使状态(沉默)
                            可以招募
                            读取所有单位位置
                            重置所有队伍/单位：全体复活，满血满蓝，归位
                              
            5秒的时候 stat=1 全体防守加状态 (禁锢 缴械 无敌 沉默) 
                            禁止招募
                            记录所有单位位置

            3秒的时候       读取所有单位位置
                            刷怪
                            全体进攻加状态 (禁锢 缴械 无敌 沉默) 

            0秒      stat=2 全体 解除状态
                            刷新羁绊
                            禁止招募
                            拆长城
                            加信使状态(沉默)

            全部进攻方单位死完，重置倒计时

### 写一个羁绊，

        准备阶段倒数5秒时
        1 遍历所有modifier 遍历table01 如果表中没有该BUFF，插入table01 否则不插入
        2 遍历    table01 遍历羁绊KV   如果值对键 相同 插入table02 值为真  否则值为假
        3 遍历所有modifier 遍历table02 如果值对键 相同 改变该羁绊状态

    羁绊要求
        羁绊写一个启动用的修饰器，数据驱动类
        羁绊要写在技能7到技能11中

### 搜将
    1.1 前端：  按钮(搜将)，
                    判断点将台现存量，满了提示(点将台已满)，否则
                    判断玩家余额，不足提示(余额不足) 否则
                    否则发送事件 （玩家ID，己势力/全阵营）find_wujiang(id,way:country/hero)
    1.2 服务器：响应事件， 扣钱  转1.4
    1.4 服务器：随机一个英雄单位，发送事件 ( 玩家 英雄 英雄名字 或 失败)
    1.5 前端：  响应事件，点将台个数+1 在点将台创建子板 按钮类型 调用英雄头像 或 提示(未搜到)

    2   送兵
    2.1 服务器：新轮(准备阶段？) 随机5个生物 发送事件 (玩家 杂兵 杂兵名字)
    2.2 前端：  响应事件，
                    判断点将台现存量，满了(提示点将台空位不足？)，否则
                    点将台个数+1/次 在点将台创建子板 按钮类型 调用物品头像

    3   招募
    3.1 前端：  按钮(单位)，
                    判断玩家人口现存量，满了提示(人口已满)，否则
                    判断玩家余额，不足提示(余额不足) 否则 发送事件 单位名字 
    3.4 服务器：响应事件，扣钱 创建单位，发送事件 已创建 单位名字 花费人口
    3.5 前端：  删除按钮(单位) 点将台个数-1 人口-花费