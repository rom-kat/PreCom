﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетаНаОплатуПокупателю.ТипЗначения = Новый ОписаниеТипов("ДокументСсылка.СчетНаОплатуПокупателю");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивПлатежей(ПоступлениеДСРС)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СчетНаОплату КАК СчетНаОплату,
	|	ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СуммаПлатежа КАК СуммаПлатежа,
	|	ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.КурсВзаиморасчетов КАК КурсВзаиморасчетов,
	|	ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СуммаНДС КАК СуммаНДС,
	|	ПоступлениеНаРасчетныйСчет.Организация КАК Организация,
	|	ПоступлениеНаРасчетныйСчет.Контрагент КАК Контрагент,
	|	ОбъектыLogiSmart.ID_LS КАК ID_LS
	|ИЗ
	|	Документ.ПоступлениеНаРасчетныйСчет.РасшифровкаПлатежа КАК ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПоступлениеНаРасчетныйСчет КАК ПоступлениеНаРасчетныйСчет
	|		ПО ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.Ссылка = ПоступлениеНаРасчетныйСчет.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыLogiSmart КАК ОбъектыLogiSmart
	|		ПО ПоступлениеНаРасчетныйСчетРасшифровкаПлатежа.СчетНаОплату = ОбъектыLogiSmart.Объект
	|ГДЕ
	|	ПоступлениеНаРасчетныйСчет.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ПоступлениеДСРС);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивСчетовLS = Новый Массив;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивСчетовLS.Добавить(ВыборкаДетальныеЗаписи.ID_LS);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	dbo_Разноска_Платежей.Ссылка КАК Ссылка,
	|	dbo_Разноска_Платежей.ID КАК ID,
	|	dbo_Разноска_Платежей.ID_Счет КАК ID_Счет,
	|	dbo_Разноска_Платежей.ID_Платеж КАК ID_Платеж,
	|	dbo_Разноска_Платежей.CurTime КАК CurTime,
	|	dbo_Разноска_Платежей.CurUser КАК CurUser,
	|	dbo_Разноска_Платежей.Сумма КАК Сумма,
	|	dbo_Разноска_Платежей.ДатаКурса КАК ДатаКурса,
	|	dbo_Разноска_Платежей.КурсРазноски КАК КурсРазноски,
	|	dbo_Разноска_Платежей.ID_Способ_Разноски КАК ID_Способ_Разноски,
	|	dbo_Разноска_Платежей.СуммаПлатеж КАК СуммаПлатеж,
	|	dbo_Разноска_Платежей.ID_Монолит КАК ID_Монолит,
	|	dbo_Разноска_Платежей.CurEditTime КАК CurEditTime,
	|	dbo_Разноска_Платежей.CurEditUser КАК CurEditUser,
	|	dbo_Разноска_Платежей.Раздел_Дебет КАК Раздел_Дебет,
	|	dbo_Разноска_Платежей.Знак_Дебет КАК Знак_Дебет,
	|	dbo_Разноска_Платежей.Раздел_Кредит КАК Раздел_Кредит,
	|	dbo_Разноска_Платежей.Знак_Кредит КАК Знак_Кредит,
	|	dbo_Платеж.ID_Контрагент КАК ID_Контрагент,
	|	dbo_Платеж.ID_Направление КАК ID_Направление,
	|	dbo_Платеж.ID_Валюта КАК ID_Валюта,
	|	dbo_Платеж.ID_Собственная_фирма КАК ID_Собственная_фирма,
	|	dbo_Платеж.Ссылка КАК Платеж
	|ИЗ
	|	ВнешнийИсточникДанных.LogiSmart.Таблица.dbo_Разноска_Платежей КАК dbo_Разноска_Платежей
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.LogiSmart.Таблица.dbo_Платеж КАК dbo_Платеж
	|		ПО dbo_Разноска_Платежей.ID_Платеж = dbo_Платеж.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВнешнийИсточникДанных.LogiSmart.Таблица.dbo_Счет КАК dbo_Счет
	|		ПО dbo_Разноска_Платежей.ID_Счет = dbo_Счет.Ссылка
	|ГДЕ
	|	dbo_Счет.ID В(&МассивСчетовLS)";
	
	Запрос.УстановитьПараметр("МассивСчетовLS", МассивСчетовLS);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивПлатежейLS = Новый Массив;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		МассивПлатежейLS.Добавить(ВыборкаДетальныеЗаписи.Платеж);
	КонецЦикла;
	
	Возврат МассивПлатежейLS;

КонецФункции // ПолучитьМассивПлатежей()

&НаСервере
Функция ПолучитьIDОбъектLS(ОбъектСсылка)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОбъектыLogiSmart.ID_LS КАК ID_LS
		|ИЗ
		|	РегистрСведений.ОбъектыLogiSmart КАК ОбъектыLogiSmart
		|ГДЕ
		|	ОбъектыLogiSmart.Объект = &Объект";
	
	Запрос.УстановитьПараметр("Объект", ОбъектСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
		Возврат	ВыборкаДетальныеЗаписи.ID_LS;
	КонецЕсли;
	
	Возврат "";
	
КонецФункции // ПолучитьIDОбъектLS()

&НаСервереБезКонтекста
Функция ПолучитьСтрокуСоединения()
	
	ПараметрыСоединения = ВнешниеИсточникиДанных.LogiSmart.ПолучитьОбщиеПараметрыСоединения();	
	СтрокаСоединения = ПараметрыСоединения.СтрокаСоединения;	
	
	Возврат СтрокаСоединения;
	
КонецФункции // ПолучитьСтрокуСоединения()

&НаСервере
Процедура ЗаписатьПлатежиLSНаСервере()
	
	Для Каждого СтрокаПоступленияДС Из ПоступленияДС Цикл
		Если ЗначениеЗаполнено(СтрокаПоступленияДС.ДоговорLS) И ЗначениеЗаполнено(СтрокаПоступленияДС.КонтрагентLS) Тогда
			Если Не ЗначениеЗаполнено(СтрокаПоступленияДС.ВходящийПлатежLS) Тогда
				
				СтруктураРезультаПроверки = ОбщийМодульItsLabs.ПроверкаОтправкиПлатежейLS(СтрокаПоступленияДС.ПоступлениеНаРасчетныйСчет);
				СтруктураРезультаПроверки.Вставить("ОбъектСсылка", СтрокаПоступленияДС.ПоступлениеНаРасчетныйСчет);
				ОбщийМодульItsLabs.ОтправкаПлатежейLS(СтрокаПоступленияДС.ПоступлениеНаРасчетныйСчет, Параметры); 
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
	
&НаКлиенте
Процедура ЗаписатьПлатежиLS(Команда)
	ЗаписатьПлатежиLSНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВыбратьВходящиеПлатежиНаСервере(КомандаИмя)
	
	Если КомандаИмя="ВыбратьВходящиеПлатежи" Тогда
		ТЗДС_Имя = "ПоступленияДС";
		Таб_ДС = "ПоступлениеНаРасчетныйСчет";
	ИначеЕсли КомандаИмя="ВыбратьИсходящиеПлатежи" Тогда	
		ТЗДС_Имя = "СписаниеДС";
		Таб_ДС = "СписаниеСРасчетногоСчета";
	КонецЕсли;
	
	
	ТЗДС = РеквизитФормыВЗначение(ТЗДС_Имя, Тип("ТаблицаЗначений"));
	ТЗДС.Очистить();
	
	Если (КомандаИмя="ВыбратьВходящиеПлатежи" И ЗначениеЗаполнено(СчетаНаОплатуПокупателю)) Или ЗначениеЗаполнено(Контрагент) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	РасшифровкаПлатежа.Ссылка КАК Ссылка
			|ИЗ
			|	Документ."+Таб_ДС+".РасшифровкаПлатежа КАК РасшифровкаПлатежа
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ."+Таб_ДС+" КАК ДСРасчетныйСчет
			|		ПО РасшифровкаПлатежа.Ссылка = ДСРасчетныйСчет.Ссылка
			|ГДЕ
			|	1=1
			|	"+?((КомандаИмя="ВыбратьВходящиеПлатежи" И ЗначениеЗаполнено(СчетаНаОплатуПокупателю)), "И РасшифровкаПлатежа.СчетНаОплату В(&СчетаНаОплату)", "")+"
			|	"+?(ЗначениеЗаполнено(Контрагент), "И ДСРасчетныйСчет.Контрагент = &Контрагент", "")+"";
		
		Запрос.УстановитьПараметр("СчетаНаОплату", СчетаНаОплатуПокупателю);
		Запрос.УстановитьПараметр("Контрагент", Контрагент);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		МассивДС = Новый Массив;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			МассивДС.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДСНаРасчетныйСчет.Ссылка КАК ДвижениеДСНаРасчетныйСчет,
		|	ДСНаРасчетныйСчет.Контрагент КАК Контрагент,
		|	ДСНаРасчетныйСчет.ДоговорКонтрагента КАК ДоговорКонтрагента,
		|	ДСНаРасчетныйСчет.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
		|	ДСНаРасчетныйСчет.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
		|	ДСНаРасчетныйСчет.СуммаДокумента КАК СуммаДС
		|ИЗ
		|	Документ."+Таб_ДС+" КАК ДСНаРасчетныйСчет
		|ГДЕ
		|	ДСНаРасчетныйСчет.Дата МЕЖДУ &НачалоПериода И &ОкончаниеПериода
		|	"+?((КомандаИмя="ВыбратьВходящиеПлатежи" И ЗначениеЗаполнено(СчетаНаОплатуПокупателю)) Или ЗначениеЗаполнено(Контрагент), "И ДСНаРасчетныйСчет.Ссылка В(&МассивДС)", "");
	
	Запрос.УстановитьПараметр("НачалоПериода", ПериодВыбораПлатежей.ДатаНачала);
	Запрос.УстановитьПараметр("ОкончаниеПериода", ПериодВыбораПлатежей.ДатаОкончания);
	
	Если (КомандаИмя="ВыбратьВходящиеПлатежи" И ЗначениеЗаполнено(СчетаНаОплатуПокупателю)) Или ЗначениеЗаполнено(Контрагент) Тогда
		Запрос.УстановитьПараметр("МассивДС", МассивДС);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		СтруктураРезультаПроверки = ОбщийМодульItsLabs.ПроверкаОтправкиПлатежейLS(ВыборкаДетальныеЗаписи.ДвижениеДСНаРасчетныйСчет);
		
		Если СтруктураРезультаПроверки.Выгружать Тогда
			
			НоваяСтрокаТЗ = ТЗДС.Добавить();
			Если КомандаИмя="ВыбратьВходящиеПлатежи" Тогда
				НоваяСтрокаТЗ.ПоступлениеНаРасчетныйСчет = ВыборкаДетальныеЗаписи.ДвижениеДСНаРасчетныйСчет;
				НоваяСтрокаТЗ.СуммаПРС = ВыборкаДетальныеЗаписи.СуммаДС;
			Иначе
				НоваяСтрокаТЗ.СписаниеСРасчетногоСчета = ВыборкаДетальныеЗаписи.ДвижениеДСНаРасчетныйСчет;
				НоваяСтрокаТЗ.СуммаСРС = ВыборкаДетальныеЗаписи.СуммаДС;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТЗ, ВыборкаДетальныеЗаписи);
			МассивДоговоров = ВыборкаДетальныеЗаписи.ДвижениеДСНаРасчетныйСчет.РасшифровкаПлатежа.ВыгрузитьКолонку("ДоговорКонтрагента");
			ДоговорIDLS = ОбщийМодульItsLabs.ПолучитьIDОбъектLS(МассивДоговоров);
			Если ДоговорIDLS<>Неопределено Тогда
				НоваяСтрокаТЗ.ДоговорLS = ОбщийМодульItsLabs.ПолучитьОбъектСсылкаLS(ДоговорIDLS, "dbo_Документ");
			КонецЕсли;
			
			КонтрагентIDLS = ОбщийМодульItsLabs.ПолучитьIDОбъектLS(ВыборкаДетальныеЗаписи.Контрагент);
			Если КонтрагентIDLS<>Неопределено Тогда
				НоваяСтрокаТЗ.КонтрагентLS = ОбщийМодульItsLabs.ПолучитьОбъектСсылкаLS(КонтрагентIDLS, "dbo_Контрагент");
			КонецЕсли;
			
			ID_LS_Платеж = "";
			Если СтруктураРезультаПроверки.ВыгруженоРанее Тогда
				НоваяСтрокаТЗ.Соответствие = "Установлено";
				ID_LS_Платеж = СтруктураРезультаПроверки.ID_LS;
			Иначе 
				МассивПлатежей = ОбщийМодульItsLabs.ПолучитьМассивПлатежей(ВыборкаДетальныеЗаписи.ДвижениеДСНаРасчетныйСчет);
				Если МассивПлатежей.Количество()>0 Тогда
					ID_LS_Платеж = МассивПлатежей[0].ID;
					НоваяСтрокаТЗ.Соответствие = "Найдено по счетам";
				КонецЕсли;
			КонецЕсли;
			
			Если Не ПустаяСтрока(ID_LS_Платеж) Тогда
				
				Если КомандаИмя="ВыбратьВходящиеПлатежи" Тогда 
					СтрокаПоляLS = "ВходящийПлатежLS";
					СтрокаПоляПлатежаLS = "ВходящийПлатежLS, СуммаПлатежLS, НомерПП, ДатаПП";
				Иначе
					СтрокаПоляПлатежаLS = "ИсходящийПлатежLS, СуммаПлатежLS, НомерПП, ДатаПП";
					СтрокаПоляLS = "ИсходящийПлатежLS";
				КонецЕсли;

				
				ЗапросПлатёж = Новый Запрос;
				ЗапросПлатёж.Текст = "ВЫБРАТЬ
				                     |	dbo_Платеж.Ссылка КАК "+СтрокаПоляLS+",
				                     |	dbo_Платеж.Сумма КАК СуммаПлатежLS,
				                     |	dbo_Платеж.НомерПП КАК НомерПП,
				                     |	dbo_Платеж.Дата КАК ДатаПП
				                     |ИЗ
				                     |	ВнешнийИсточникДанных.LogiSmart.Таблица.dbo_Платеж КАК dbo_Платеж
				                     |ГДЕ
				                     |	dbo_Платеж.ID = &ID";
				
				ЗапросПлатёж.УстановитьПараметр("ID", ID_LS_Платеж);
				
				РезультатЗапросаПлатеж = ЗапросПлатёж.Выполнить();
				
				ВыборкаДетальныеЗаписиПлатёж = РезультатЗапросаПлатеж.Выбрать();
												
				Если ВыборкаДетальныеЗаписиПлатёж.Следующий() Тогда 
					ЗаполнитьЗначенияСвойств(НоваяСтрокаТЗ, ВыборкаДетальныеЗаписиПлатёж, СтрокаПоляПлатежаLS);
				КонецЕсли;
				
	 		КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ТЗДС, ТЗДС_Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВходящиеПлатежи(Команда)
	ВыбратьВходящиеПлатежиНаСервере(Команда.Имя);
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаличиеПлатежейLSНаСервере()
	//Для каждого ПоступлениеДС Из ПоступленияДС Цикл
	//
	//	МассивПлатежейLS = Полу	
	//
	//КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеПлатежейLS(Команда)
	ПроверитьНаличиеПлатежейLSНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПоказатьСчетаПлатежаНаСервере(ТекущаяСтрока)
	
	ТЗСчетаОплаты = РеквизитФормыВЗначение("СчетаОплаты", Тип("ТаблицаЗначений"));
	ТЗСчетаОплаты.Очистить();
	
	//СтрокаПоступленияДС = ПоступленияДС[ТекущаяСтрока];
	СтрокаПоступленияДС = ПоступленияДС.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасшифровкаПлатежа.СчетНаОплату КАК СчетНаОплату,
		|	РасшифровкаПлатежа.СуммаПлатежа КАК Сумма
		|ПОМЕСТИТЬ ВТ_СчетаПлатежей
		|ИЗ
		|	Документ.ПоступлениеНаРасчетныйСчет.РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|ГДЕ
		|	РасшифровкаПлатежа.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетНаОплатуПокупателюТовары.Ссылка КАК СчетНаОплату,
		|	СУММА(СчетНаОплатуПокупателюТовары.Сумма) КАК СуммаСчета,
		|	СУММА(ВТ_СчетаПлатежей.Сумма) КАК Сумма,
		|	СчетНаОплатуПокупателюТовары.Ссылка.ДоговорКонтрагента КАК Договор
		|ИЗ
		|	Документ.СчетНаОплатуПокупателю.Товары КАК СчетНаОплатуПокупателюТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СчетаПлатежей КАК ВТ_СчетаПлатежей
		|		ПО СчетНаОплатуПокупателюТовары.Ссылка = ВТ_СчетаПлатежей.СчетНаОплату
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетНаОплатуПокупателюТовары.Ссылка,
		|	СчетНаОплатуПокупателюТовары.Ссылка.ДоговорКонтрагента";
	
	Запрос.УстановитьПараметр("Ссылка",СтрокаПоступленияДС.ПоступлениеНаРасчетныйСчет);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТЗСчетаОплаты = ТЗСчетаОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЗСчетаОплаты, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СтрокаПоступленияДС.ВходящийПлатежLS) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	dbo_Разноска_Платежей.ID_Счет КАК ID_Счет,
			|	dbo_Разноска_Платежей.Сумма КАК Сумма
			|ИЗ
			|	ВнешнийИсточникДанных.LogiSmart.Таблица.dbo_Разноска_Платежей КАК dbo_Разноска_Платежей
			|ГДЕ
			|	dbo_Разноска_Платежей.ID_Платеж = &ID_Платеж";
		
		Запрос.УстановитьПараметр("ID_Платеж", СтрокаПоступленияДС.ВходящийПлатежLS);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СчетНаОплату = ОбщийМодульItsLabs.ПолучитьОбъектПоID(ВыборкаДетальныеЗаписи.ID_Счет.ID, "Документ.СчетНаОплатуПокупателю");
			СтрокаТЗСчетаОплаты = ТЗСчетаОплаты.Найти(СчетНаОплату, "СчетНаОплату");
			Если СтрокаТЗСчетаОплаты=Неопределено Тогда
				СтрокаТЗСчетаОплаты = ТЗСчетаОплаты.Добавить();
			КонецЕсли;
			СтрокаТЗСчетаОплаты.СчетНаОплатуLS = ВыборкаДетальныеЗаписи.ID_Счет;
			СтрокаТЗСчетаОплаты.СуммаLS = ВыборкаДетальныеЗаписи.Сумма;
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТЗСчетаОплаты, "СчетаОплаты");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСчетаПлатежа(Команда)
	ПоказатьСчетаПлатежаНаСервере(Элементы.ПоступленияДС.ТекущаяСтрока);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоговорыКонтрагентовПустаяСсылка()
	Возврат Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
КонецФункции

&НаКлиенте
Процедура ПоступленияДСВходящийПлатежLSПриИзменении(Элемент)
	ОбъектLS = Элементы.ПоступленияДС.ТекущиеДанные.ВходящийПлатежLS;
	ОбъектСсылка = Элементы.ПоступленияДС.ТекущиеДанные.ПоступлениеНаРасчетныйСчет;
	Если ЗначениеЗаполнено(ОбъектLS) Тогда
		ВалютаДоговора = ДоговорыКонтрагентовПустаяСсылка();
		ID_LS = ОбщийМодульItsLabs.ПолучитьРеквизитШапкиПоСсылке(ОбъектLS, "ID");
		ОбщийМодульItsLabs.ЗаписатьОбъектыLogiSmart(ОбъектСсылка, ID_LS,,, ВалютаДоговора);
		Элементы.ПоступленияДС.ТекущиеДанные.Соответствие = "Установлено";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоступленияДСВходящийПлатежLSОчистка(Элемент, СтандартнаяОбработка)
	
	ОбъектLS = Элементы.ПоступленияДС.ТекущиеДанные.ВходящийПлатежLS;
	ОбъектСсылка = Элементы.ПоступленияДС.ТекущиеДанные.ПоступлениеНаРасчетныйСчет;
	Если ЗначениеЗаполнено(ОбъектLS) Тогда
		ВалютаДоговора = ДоговорыКонтрагентовПустаяСсылка();
		ID_LS = ОбщийМодульItsLabs.ПолучитьРеквизитШапкиПоСсылке(ОбъектLS, "ID");
		ОбщийМодульItsLabs.ЗаписатьОбъектыLogiSmart(ОбъектСсылка, ID_LS,, Истина, ВалютаДоговора);
		Элементы.ПоступленияДС.ТекущиеДанные.Соответствие = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписаниеДСИсходящийПлатежLSПриИзменении(Элемент)
	ОбъектLS = Элементы.СписаниеДС.ТекущиеДанные.ИсходящийПлатежLS;
	ОбъектСсылка = Элементы.СписаниеДС.ТекущиеДанные.СписаниеСРасчетногоСчета;
	Если ЗначениеЗаполнено(ОбъектLS) Тогда
		ВалютаДоговора = ДоговорыКонтрагентовПустаяСсылка();
		ID_LS = ОбщийМодульItsLabs.ПолучитьРеквизитШапкиПоСсылке(ОбъектLS, "ID");
		ОбщийМодульItsLabs.ЗаписатьОбъектыLogiSmart(ОбъектСсылка, ID_LS,,, ВалютаДоговора);
		Элементы.СписаниеДС.ТекущиеДанные.Соответствие = "Установлено";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписаниеДСИсходящийПлатежLSОчистка(Элемент, СтандартнаяОбработка)
	
	ОбъектLS = Элементы.СписаниеДС.ТекущиеДанные.ИсходящийПлатежLS;
	ОбъектСсылка = Элементы.СписаниеДС.ТекущиеДанные.СписаниеСРасчетногоСчета;
	Если ЗначениеЗаполнено(ОбъектLS) Тогда
		ВалютаДоговора = ДоговорыКонтрагентовПустаяСсылка();
		ID_LS = ОбщийМодульItsLabs.ПолучитьРеквизитШапкиПоСсылке(ОбъектLS, "ID");
		ОбщийМодульItsLabs.ЗаписатьОбъектыLogiSmart(ОбъектСсылка, ID_LS,, Истина, ВалютаДоговора);
		Элементы.СписаниеДС.ТекущиеДанные.Соответствие = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьСоответствиеНаСервере()
	
	Для каждого СтрокаСписаниеДС Из СписаниеДС Цикл
		
		Если СтрокаСписаниеДС.Соответствие="Найдено по счетам" Тогда
			Если СтрокаСписаниеДС.НомерВходящегоДокумента=СтрокаСписаниеДС.НомерПП Тогда
				ВалютаДоговора = ДоговорыКонтрагентовПустаяСсылка();
				ID_LS = ОбщийМодульItsLabs.ПолучитьРеквизитШапкиПоСсылке(СтрокаСписаниеДС.ИсходящийПлатежLS, "ID");
				ОбщийМодульItsLabs.ЗаписатьОбъектыLogiSmart(СтрокаСписаниеДС.СписаниеСРасчетногоСчета, ID_LS,,, ВалютаДоговора);	
			КонецЕсли;
		КонецЕсли;
		
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСоответствие(Команда)
	УстановитьСоответствиеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПоказатьСчетаПлатежаПоставщикамНаСервере(ТекущаяСтрока)
	
	ТЗСчетаОплаты = РеквизитФормыВЗначение("СчетаОплатыПоставщикам", Тип("ТаблицаЗначений"));
	ТЗСчетаОплаты.Очистить();
	
	СтрокаСписаниеДС = СписаниеДС.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РасшифровкаПлатежа.СчетНаОплату КАК СчетНаОплату,
		|	РасшифровкаПлатежа.СуммаПлатежа КАК Сумма
		|ПОМЕСТИТЬ ВТ_СчетаПлатежей
		|ИЗ
		|	Документ.СписаниеСРасчетногоСчета.РасшифровкаПлатежа КАК РасшифровкаПлатежа
		|ГДЕ
		|	РасшифровкаПлатежа.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СчетНаОплатуПоставщикаТовары.Ссылка КАК СчетНаОплатуПоставщику,
		|	СУММА(СчетНаОплатуПоставщикаТовары.Сумма) КАК СуммаСчета,
		|	СУММА(ВТ_СчетаПлатежей.Сумма) КАК Сумма,
		|	СчетНаОплатуПоставщикаТовары.Ссылка.ДоговорКонтрагента КАК Договор
		|ИЗ
		|	Документ.СчетНаОплатуПоставщика.Товары КАК СчетНаОплатуПоставщикаТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СчетаПлатежей КАК ВТ_СчетаПлатежей
		|		ПО СчетНаОплатуПоставщикаТовары.Ссылка = ВТ_СчетаПлатежей.СчетНаОплату
		|
		|СГРУППИРОВАТЬ ПО
		|	СчетНаОплатуПоставщикаТовары.Ссылка,
		|	СчетНаОплатуПоставщикаТовары.Ссылка.ДоговорКонтрагента";
	
	Запрос.УстановитьПараметр("Ссылка", СтрокаСписаниеДС.СписаниеСРасчетногоСчета);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаТЗСчетаОплаты = ТЗСчетаОплаты.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЗСчетаОплаты, ВыборкаДетальныеЗаписи);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(СтрокаСписаниеДС.ИсходящийПлатежLS) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	dbo_Разноска_Платежей.ID_Счет КАК ID_Счет,
			|	dbo_Разноска_Платежей.Сумма КАК Сумма
			|ИЗ
			|	ВнешнийИсточникДанных.LogiSmart.Таблица.dbo_Разноска_Платежей КАК dbo_Разноска_Платежей
			|ГДЕ
			|	dbo_Разноска_Платежей.ID_Платеж = &ID_Платеж";
		
		Запрос.УстановитьПараметр("ID_Платеж", СтрокаСписаниеДС.ИсходящийПлатежLS);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			СчетНаОплату = ОбщийМодульItsLabs.ПолучитьОбъектПоID(ВыборкаДетальныеЗаписи.ID_Счет.ID, "Документ.СчетНаОплатуПоставщика");
			СтрокаТЗСчетаОплаты = ТЗСчетаОплаты.Найти(СчетНаОплату, "СчетНаОплатуПоставщику");
			Если СтрокаТЗСчетаОплаты=Неопределено Тогда
				СтрокаТЗСчетаОплаты = ТЗСчетаОплаты.Добавить();
			КонецЕсли;
			СтрокаТЗСчетаОплаты.СчетНаОплатуLS = ВыборкаДетальныеЗаписи.ID_Счет;
			СтрокаТЗСчетаОплаты.СуммаLS = ВыборкаДетальныеЗаписи.Сумма;
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТЗСчетаОплаты, "СчетаОплатыПоставщикам");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСчетаПлатежаПоставщикам(Команда)
	ПоказатьСчетаПлатежаПоставщикамНаСервере(Элементы.СписаниеДС.ТекущаяСтрока)
КонецПроцедуры


