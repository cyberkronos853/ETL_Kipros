//++ 09.03.2025 Кибернетика Корыткин А.А. 
Процедура ЗаполнитьТехническиеТаблицы() Экспорт
	
	ОбменSQL = Обработки.ОбменSQL.Создать();
	КомандаSQL = ОбменSQL.Соединение();
	КомандаSQL.CommandType = 1;
	
	Запрос = Новый Запрос;
	
	Команда = 
	"SET ANSI_NULLS ON
	|SET QUOTED_IDENTIFIER ON
	|
	|IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bases]') AND type in (N'U'))
	|BEGIN
	|	DROP TABLE [dbo].[Bases]		
	|END
	|	CREATE TABLE [dbo].[Bases](
	|		[Base] [nvarchar](20) NULL,
	|		[local] [bit] NULL
	|	) ON [PRIMARY]";
	
	КомандаSQL.CommandText = Команда;
	КомандаSQL.Execute();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Базы.Наименование КАК Наименование,
	|	Базы.Локальная КАК Локальная
	|ИЗ
	|	Справочник.Базы КАК Базы
	|ГДЕ
	|	НЕ Базы.Отключена
	|	И НЕ Базы.ПометкаУдаления";
	
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Команда = Команда + "
		|    
		|IF NOT EXISTS (SELECT 1 FROM Bases WHERE [Base] = '" + Выборка.Наименование + "')
		|	INSERT INTO Bases ([Base], [local]) VALUES ('" + Выборка.Наименование + "' , " + ?(Выборка.Локальная, 1,0) +")";		
	КонецЦикла;  
	
	
	КомандаSQL.CommandText = Команда;
	КомандаSQL.Execute(); 
	
		
	
КонецПроцедуры    

