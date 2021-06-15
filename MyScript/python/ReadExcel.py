import xlrd
import datetime
import calendar
import sys


path = sys.argv[1]
data_excel=xlrd.open_workbook(path)

# 获取所有sheet名称
names=data_excel.sheet_names()
table=data_excel.sheets()[0]

n_rows=table.nrows  # 获取该sheet中的有效行数
n_cols=table.ncols  # 获取该sheet中的有效列数
cols_list=table.col(colx=11)
targetTurnover = cols_list[5].value

date = names[0][4:6]
# day = names[0][]

today = datetime.date.today()
todayText = "%d月%d日" %(today.month, today.day)
monthDays = calendar.monthrange(today.year,today.month)[1]

res = ".营业数据汇总{本月（%(date)s月）目标：%(targetTurnover)s}" %{"date":today.month, "targetTurnover":targetTurnover}
res += "\n"
res += "营业时间%d月1日-%s（本月共计%d天）" %(today.month, todayText, monthDays)
res += "\n"
res += "1."
res += "\n"

# 营业总额
totalAmount = cols_list[2].value
# 日均营业额
avgAmount = cols_list[3].value
# 暂估本月营业额
estimateTotalAmount = cols_list[4].value

res += "营业总额为：%.2f元，日均营业额：%.2f元，暂估本月营业总额为：%.2f元；" %(totalAmount, avgAmount, estimateTotalAmount)
res += "\n"

# 距离本月目标差值
diff = cols_list[6].value
# 每天需要完成的目标营业额
need = cols_list[7].value
res += "本月目标%.2f，距离目标差%.2f元，每天需完成%.2f元" %(targetTurnover, diff, need)
res += "\n"
res += "2."
res += "\n"

# 会员充值金额
vip = cols_list[9].value
# 日均充值额
avgVip = cols_list[10].value
# 暂估本月充值额
estimentVip = cols_list[11].value
# 会员消费金额
vipUserConsumptionAmount = cols_list[12].value
res += "会员充值金额：%.2f元，日均：%.2f元，暂估本月会员充值金额：%.2f元" %(vip,avgVip,estimentVip)
res += "\n"
res += "会员消费金额：%.2f元" %(vipUserConsumptionAmount)
# 每屏收入
eachScreenIncome = cols_list[14].value
res += "\n"
res += "3.每屏收入：%.2f元" %(eachScreenIncome)

# 当天每屏收入
todayEachScreenIncome = cols_list[15].value
# 霸屏收入
screenIncome = cols_list[16].value
# 点播收入
musicIncome = cols_list[17].value
# 购买酒水
drinksIncome = cols_list[18].value
res += "\n"
res += "4."
res += "\n"
res += "当天每屏收入：%.2f元" %(todayEachScreenIncome)
res += "霸屏收入：%.2f元" %(screenIncome)
res += "点播收入：%.2f元" %(musicIncome)
res += "购买酒水：%.2f元" %(drinksIncome)
res += "\n"
res += "请各位领导查收数据！"

print(res)


