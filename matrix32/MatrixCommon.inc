{
Copyright (c) 2005-2013, Loginov Dmitry Sergeevich
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}

{ *************************************************************************** }
{                                                                             }
{                                                                             }
{                                                                             }
{ Модуль MatrixCommon - хранит общие для разных модулей директивы компиляции  }
{ Последнее обновление: 03.03.2007                                            }
{ Адрес сайта: http://loginovprojects.ru/                                     }
{ e-mail: loginov_d@inbox.ru                                                  }
{                                                                             }
{ *************************************************************************** }

{Уберите . если вы хотите, чтобы Matrix32 выполнял проверку наличия заданного
 элемента массива. Это может привести к более медленной работе системы, однако
 поможет найти труднообнаруживаемые ошибки. При включенной директиве также
 будет включена защита операций записи/чтения элементоа массива.
 Обязательно тестируйте приложения Matrix32 с данной директирой во время разработки.
 Не забудьте отключать эту опцию при компиляции финальных версий своих проектов}
{.$DEFINE MatrixCheckRange}

{Уберите . если вы хотите, чтобы все классы объектов TMatrix регистрировались
 в списке классов MatrixClassList. Благодаря этому, операции по работе с потоками
 и файлами автоматически создают объекты заданных классов при загрузке объектов
 из потоков или файлов}
{$DEFINE RegisterMatrixClasses}

{Уберите . если вы хотите, чтобы внутри секций except...end, имеющихся во многих
 функциях Matrix32, генерировался год пересоздания объекта исключения с целью
 включения в текст исключения дополнительной отладочной информации (отладочная
 информация включается с помощью функции AddDebugInfoToExceptObject, которая
 объявлена в модуле Matrix32).
 Кроме того, подробную информацию о возникшем исключении
 вы можете узнать и без этой опции, если будете использовать соответствующие
 средства отладки (например, библиотеку JEDI (http://sourceforge.net/projects/jcl)}
{$DEFINE RecreateEObj}

{При включенной опции UseResStr все сообщения об ошибках объявляются
 с директивой resourcestring. При выключенной опции сообщения объявляются
 как простые текстовые переменные (т.е. через var). Во втором случае можно
 определить свой формат хранения сообщений. Модуль MatrixTranslate.pas использует
 формат, при котором текстовые сообщения хранятся в ini-файлах. Это основной
 формат с которым работает авторский модуль трансляции LangReader}
{$DEFINE UseResStr}

{Опция BLASLoadLibOnInit используется в модуле matrixBLAS.pas. Если опция включена,
 то в часть инициализации модуля matrixBLAS будет включен код загрузки библиотеки
 matrixatlas.dll. Если опция выключена, то загрузку библиотеки требуется выполнять
 вручную с помощью функции LoadBLASLibrary}
{$DEFINE BLASLoadLibOnInit}

{Опция LapackLoadLibOnInit используется в модуле matrixLapack.pas. Если опция включена,
 то в часть инициализации модуля matrixLapack будет включен код загрузки библиотеки
 matrixlapack.dll. Если опция выключена, то загрузку библиотеки требуется выполнять
 вручную с помощью функции LoadLapackLibrary}
{$DEFINE LapackLoadLibOnInit}
