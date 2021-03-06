package com.db
{
	import mx.collections.ArrayCollection;

	public class LocalDataBase
	{
		public static const areaData:ArrayCollection = new ArrayCollection(
			[
				{label:"北京",group:"B",
					child:[
						{label:"北京市",
							child:[
								{label:"北京1"},
								{label:"北京2"},
								{label:"北京3"},
								{label:"北京4"},
								{label:"北京5"},
								{label:"北京6"}
							]}
					]},
				{label:"天津",group:"T",
					child:[
						{label:"天津市",
							child:[
								{label:"天津1"},
								{label:"天津2"},
								{label:"天津3"}
							]}
					]},
				{label:"河北省",group:"H",
					child:[
						{label:"石家庄市",
							child:[
								{label:"石家庄1"},
								{label:"石家庄2"},
								{label:"石家庄3"}
							]
						},
						{label:"唐山市",
							child:[
								{label:"唐山1"},
								{label:"唐山2"},
								{label:"唐山3"}
							]
						},
						{label:"秦皇岛市",
							child:[
								{label:"秦皇岛1"},
								{label:"秦皇岛2"}
							]
						}
					]},
				{label:"山西省",group:"S",
					child:[
						{label:"太原市",
							child:[
								{label:"太原1"},
								{label:"太原2"},
								{label:"太原3"},
								{label:"太原4"},
								{label:"太原5"}
							]
						},
						{label:"大同市",
							child:[
								{label:"大同1"},
								{label:"大同2"},
								{label:"大同3"},
								{label:"大同4"},
								{label:"大同5"}
							]
						}
					]
				},
				{label:"江苏省",group:"J",
					child:[
						{label:"南京市",
							child:[
								{label:"南京1"},
								{label:"南京2"},
								{label:"南京3"}
							]
						},
						{label:"无锡市",
							child:[
								{label:"无锡1"},
								{label:"无锡2"},
								{label:"无锡3"}
							]
						}
					]
				},
				{label:"浙江省",group:"Z",
					child:[
						{label:"杭州市",
							child:[
								{label:"杭州1"},
								{label:"杭州2"},
								{label:"杭州3"}
							]
						},
						{label:"宁波市",
							child:[
								{label:"宁波1"},
								{label:"宁波2"},
								{label:"宁波3"}
							]
						}
					]
				}
			]
		);
			
		public static const classData:ArrayCollection = new ArrayCollection(
			[
				{label:"机电系",
					child:[
						{label:"通信专业",
							child:[
								{label:"通信1班"},
								{label:"通信2班"},
								{label:"通信3班"}
							]
						},
						{label:"电子专业",
							child:[
								{label:"电子1班"},
								{label:"电子2班"},
								{label:"电子3班"},
								{label:"电子4班"},
								{label:"电子5班"}
							]
						}
					]
				},
			]
		);
			
		public static const organizeData:ArrayCollection = new ArrayCollection(
			[
				{label:"业务部",
					child:[
						{label:"业务1"},
						{label:"业务2"},
						{label:"客服"}
					]
				},
				{label:"运营部",
					child:[
						{label:"仓储"},
						{label:"运作"}
					]
				},
				{label:"财务部",
					child:[
						{label:"会计"},
						{label:"出纳"},
						{label:"财务"}
					]
				},
				{label:"管理部",
					child:[
						{label:"人力资源"},
						{label:"总务"},
						{label:"采购"}
					]
				},
			]
		);
			
			
			
			
	}
}