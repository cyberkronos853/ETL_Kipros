#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗаполнитьСкриптОчисткиВременныхТаблицЭталонов(ТекстКоманды = "") Экспорт
	
	СпрОбъект = Справочники.ПроцедурыSQL.ОчисткаВременныхТаблицЭталонов.ПолучитьОбъект();
	ТекстКоманды = "DECLARE @name VARCHAR(100) 
		|DECLARE db_cursor CURSOR FOR 
		|SELECT name 
		|FROM sys.objects 
		|WHERE type in (N'U') AND name like '%_temp'
		|OPEN db_cursor  
		|FETCH NEXT FROM db_cursor INTO @name  
		|WHILE @@FETCH_STATUS = 0  
		|BEGIN  
		|      execute ('TRUNCATE TABLE ' + @name)
		|      FETCH NEXT FROM db_cursor INTO @name 
		|END 
		|CLOSE db_cursor  
		|DEALLOCATE db_cursor"; 
	СпрОбъект.ТекстКоманды = ТекстКоманды;
	СпрОбъект.Записать();	
	
КонецПроцедуры 

Процедура ЗаполнитьСкриптОчисткиВременныхТаблиц(ТекстКоманды = "") Экспорт
	
	СпрОбъект = Справочники.ПроцедурыSQL.ОчисткаВременныхТаблиц.ПолучитьОбъект();
	ТекстКоманды = "DECLARE @name VARCHAR(100) 
		|DECLARE db_cursor CURSOR FOR 
		|SELECT name 
		|FROM sys.objects 
		|WHERE type in (N'U') AND name like '%_tmp'
		|OPEN db_cursor  
		|FETCH NEXT FROM db_cursor INTO @name  
		|WHILE @@FETCH_STATUS = 0  
		|BEGIN  
		|      execute ('TRUNCATE TABLE ' + @name)
		|      FETCH NEXT FROM db_cursor INTO @name 
		|END 
		|CLOSE db_cursor  
		|DEALLOCATE db_cursor"; 
	СпрОбъект.ТекстКоманды = ТекстКоманды;
	СпрОбъект.Записать();	
	
КонецПроцедуры

	
#КонецОбласти