
&НаСервере
Процедура СформироватьНаСервере()
	ТЗ = Выборка();
	//ИтогоТЗ = ТЗ.Скопировать();
	//ИтогоТЗ.Свернуть("Account","AmountDt,AmountKt");
	
	
	отОб = РеквизитФормыВЗначение("Отчет");
	Макет = отОб.ПолучитьМакет("Макет");
	
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.Период = "Отчет с "+Формат(Дата1,"ДЛФ=DD")+" по "+Формат(КонецДня(Дата2),"ДЛФ=DD");
	Шапка.Параметры.Организация = Организация;
	
	
	ТаблДокумент = Результат;
	ТаблДокумент.Очистить();
	
	ТаблДокумент.Вывести(Шапка);
	
	ОблСчетИтого 	= Макет.ПолучитьОбласть("СчетИтого");
	ОблСтрока 		= Макет.ПолучитьОбласть("Строка");
	
	запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВидыДвиженияКорреспонденция.Ссылка КАК Ссылка,
	               |	ВидыДвиженияКорреспонденция.Ссылка.КодСправочника КАК КодСправочника,
	               |	ВидыДвиженияКорреспонденция.Ссылка.ФормироватьПоСальдо КАК ФормироватьПоСальдо,
	               |	ВидыДвиженияКорреспонденция.Счет.КодСправочника КАК Счет,
	               |	ВидыДвиженияКорреспонденция.КорСчет.КодСправочника КАК КорСчет,
	               |	ВидыДвиженияКорреспонденция.ТипДвижения КАК ТипДвижения,
	               |	ВидыДвиженияКорреспонденция.Ссылка.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.ВидыДвижения.Корреспонденция КАК ВидыДвиженияКорреспонденция
	               |ГДЕ
	               |	НЕ ВидыДвиженияКорреспонденция.Ссылка.НеИспользуется";
	ТЗВидыДвижений = Запрос.Выполнить().Выгрузить();
	
	
	
	ТекСчет = Неопределено;
	Для Каждого Стр Из ТЗ Цикл
		
		НайденныеСтроки = ТЗВидыДвижений.НайтиСтроки(Новый Структура("Счет,КорСчет",Стр.Account,Стр.CorAccount));
		Если НайденныеСтроки.Количество()>0 тогда
			//Сообщить("Счет - Корсчет указан в более чем одном виде движений");
			для каждого стрН из НайденныеСтроки Цикл
				Если Стр.TypeOfTurnovers = "Дт" и стрН.ТипДвижения = Перечисления.ТипыДвиженияДтКт.ОборотДт тогда 
					Стр.КодВидДвижения 	= стрН.КодСправочника;
					Стр.ВидДвижения 	= стрН.Наименование;
				КонецЕсли;
				
				Если Стр.TypeOfTurnovers = "Кт" и стрН.ТипДвижения = Перечисления.ТипыДвиженияДтКт.ОборотКт тогда 
					Стр.КодВидДвижения 	= стрН.КодСправочника;
					Стр.ВидДвижения 	= стрН.Наименование;
				КонецЕсли;
				
			КонецЦикла;	
			
		КонецЕсли;	
		
		
		//Если ТекСчет <> Стр.Account Тогда
		//	
		//	ОблСчетИтого.Параметры.Account = Стр.Account;
		//	Найденнаястрока = ИтогоТЗ.найти(Стр.Account,"Account");
		//	Если Найденнаястрока<>Неопределено тогда
		//		ОблСчетИтого.Параметры.AmountDt = Найденнаястрока.AmountDt;
		//		ОблСчетИтого.Параметры.AmountKt = Найденнаястрока.AmountKt;
		//	КонецЕсли;	
		//	ТаблДокумент.Вывести(ОблСчетИтого);
		//	ТекСчет = Стр.Account;
		//КонецЕсли;
		
		//выведим общий итог
		ОблСтрока.Параметры.Заполнить(Стр);
		ТаблДокумент.Вывести(ОблСтрока);
		
	КонецЦикла;
	
	//ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	//ОбластьПодвал.Параметры.Руководитель = Руководитель;
	
	//ТаблДокумент.Вывести(ОбластьПодвал);
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

//********************************************************************************************************

Функция Выборка() Экспорт
	Таблица = Новый ТаблицаЗначений;
	
	Команда = ПолучениеОтчетов.Соединение();
	
	
	//Запрос = "
	//|SELECT 
	//|Sc.Code as Account,
	//|CorSch.Code as CorAccount,
	//|TofM.Code as КодВидДвижения,
	//|TofM.Name as ВидДвижения,
	//|TrnOver.TypeOfTurnovers as TypeOfTurnovers,
	//|SuM(CASE WHEN TrnOver.TypeOfTurnovers = 'Дт' then TrnOver.RegulatedAmount else 0 END) as AmountDt,
	//|SuM(CASE WHEN TrnOver.TypeOfTurnovers = 'Кт' then TrnOver.RegulatedAmount else 0 END) as AmountKt 	
	//|FROM [BW].[dbo].[Map_Turnovers] TrnOver 
	//|left join [BW].[dbo].map_ChartOfAccounts Sc ON Account = Sc.id
	//|left join [BW].[dbo].map_ChartOfAccounts CorSch ON CorAccount = CorSch.id
	//|left join [BW].[dbo].map_TypesOfMovements TofM ON TrnOver.TypesOfMovement = TofM.id
	//|left join [BW].[dbo].[map_Organizations] Org ON TrnOver.HeadCompany = Org.id
	//|where Period between ? and ?
	//|and Org.IIN = ?
	//|group by 
	//|Sc.Code,
	//|CorSch.Code,
	//|TofM.Code,
	//|TofM.Name,
	//|TrnOver.TypeOfTurnovers
	//|order by Account,CorAccount	
	//|";
	
	Запрос = "
	|SELECT 
	|Sc.Code as Account,
	|CorSch.Code as CorAccount,
	|'' as КодВидДвижения,
	|'' as ВидДвижения,
	|TrnOver.TypeOfTurnovers as TypeOfTurnovers,
	|SuM(CASE WHEN TrnOver.TypeOfTurnovers = 'Дт' then TrnOver.RegulatedAmount else 0 END) as AmountDt,
	|SuM(CASE WHEN TrnOver.TypeOfTurnovers = 'Кт' then TrnOver.RegulatedAmount else 0 END) as AmountKt 	
	|FROM [BW].[dbo].[Map_Turnovers] TrnOver 
	|left join [BW].[dbo].map_ChartOfAccounts Sc ON Account = Sc.id
	|left join [BW].[dbo].map_ChartOfAccounts CorSch ON CorAccount = CorSch.id
	|left join [BW].[dbo].[map_Organizations] Org ON TrnOver.HeadCompany = Org.id
	|where Period between ? and ?
	|and Org.IIN = ?
	|group by 
	|Sc.Code,
	|CorSch.Code,
	|TrnOver.TypeOfTurnovers
	|order by Account,CorAccount	
	|";
	

	Попытка
		
		Param1 = Команда.CreateParameter(,8,1,,Формат(Дата1,"ДФ=гггг.ММ.дд"));
		Команда.Parameters.Append(Param1);
		
		Param2 = Команда.CreateParameter(,8,1,,Формат(Дата2,"ДФ=гггг.ММ.дд"));
		Команда.Parameters.Append(Param2);
		
		Param3 = Команда.CreateParameter(,200,1,12,Организация.БИН);
		Команда.Parameters.Append(Param3);
		
		Команда.CommandText = Запрос;
		
		Выборка = Команда.Execute();
		
		Если НЕ Выборка.BOF Тогда

			Для А = 0 По Выборка.Fields.Count - 1 Цикл
				
				ИмяСтолбца = Выборка.Fields.Item(А).Name;  
				
				Таблица.Колонки.Добавить(ИмяСтолбца);

			КонецЦикла;
			
			//Выборка.MoveFirst();
			
			Пока НЕ Выборка.EOF Цикл
				
				НоваяСтрока = Таблица.Добавить();
				
				Для А = 0 По Выборка.Fields.Count - 1 Цикл
					
					НоваяСтрока.Установить(А, Выборка.Fields(А).Value);

				КонецЦикла;

				Выборка.MoveNext();
				
			КонецЦикла;
			
		КонецЕсли;
		
	Исключение
		
		Сообщить(ОписаниеОшибки());

	КонецПопытки;
	
	Возврат Таблица;

КонецФункции
	
