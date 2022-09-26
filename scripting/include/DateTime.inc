/* This file is a part of the Eternar SDK. */

#if defined _DateTime_included_
  #endinput
#endif
#define _DateTime_included_

#define DateTime_Now -1
#define DATE_LENGTH 32

#include <TimeSpan>

enum EMonth
{
	January = 0,
	February,
	March,
	April,
	May,
	June,
	July,
	August,
	September,
	October,
	November,
	December
}

enum EDay
{
	Monday = 0,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday,
	Sunday
}

methodmap DateTime __nullable__
{
	/**
	* Initializes a new DateTime.
	*
	* @param stamp		Unix-Epoch time.
	* @return			a new DateTime with the given stamp.
	*/
	public DateTime(int stamp = DateTime_Now)
	{
		if(stamp == DateTime_Now)
			stamp = GetTime();

		return view_as<DateTime>(stamp);
	}

	/**
	* Returns the number of seconds that have elapsed since 1970-01-01T00:00:00Z.
	*/
	property int Unix
	{
		public get()
		{
			return view_as<int>(this);
		}
	}

	/**
	* Get values from the FormatTime native.
	*
	* @param value 		format (see: http://cplusplus.com/reference/clibrary/ctime/strftime.html)
	*
	* @return			Produces a date and/or time string value for a timestamp.
	*/
	public int GetValue(const char[] value)
	{
		char temp[DATE_LENGTH];
		FormatTime(temp, sizeof(temp), value, this.Unix);
		return StringToInt(temp);
	}

	/**
	* Get the year value of this datetime.
	*/
	property int Year
	{
		public get() { return this.GetValue("%Y"); }
	}

	/**
	* Get the month value of this datetime.
	*/
	property int Month
	{
		public get() { return this.GetValue("%m"); }
	}

	/**
	* Get the day value of this datetime.
	*/
	property int Day
	{
		public get() { return this.GetValue("%d"); }
	}

	/**
	* Get the hour value of this datetime.
	*/
	property int Hour
	{
		public get() { return this.GetValue("%H"); }
	}

	/**
	* Get the minute value of this datetime.
	*/
	property int Minute
	{
		public get() { return this.GetValue("%M"); }
	}

	/**
	* Get the second value of this datetime.
	*/
	property int Second
	{
		public get() { return this.GetValue("%S"); }
	}

	/**
	* Get the total amount of weeks from this datetime.
	*/
	property float TotalWeeks
	{
		public get() { return this.Unix / flSecondsPerWeek; }
	}

	/**
	* Get the total amount of days from this datetime.
	*/
	property float TotalDays
	{
		public get() { return this.Unix / flSecondsPerDay; }
	}

	/**
	* Get the total amount of hours from this datetime.
	*/
	property float TotalHours
	{
		public get() { return this.Unix / flSecondsPerHour; }
	}

	/**
	* Get the total amount of minutes from this datetime.
	*/
	property float TotalMinutes
	{
		public get() { return this.Unix / flSecondsPerMinute; }
	}

	/**
	* Get the total amount of seconds from this datetime.
	*/
	property int TotalSeconds
	{
		public get() { return this.Unix; }
	}

	/**
	* Checks whether this year is a leap year or not.
	*/
	property bool IsLeapYear
	{
		public get()
		{
			return ((this.Year % 4 == 0 && this.Year % 100 != 0) || this.Year % 400 == 0);
		}
	}

	/**
	* Returns the amount of days in the given month.
	*/
	property int DaysInMonth
	{
		public get()
		{
			int daysInMonths[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
			if(this.IsLeapYear)
				daysInMonths[February] = 29;
			
			return daysInMonths[this.Month - 1];
		}
	}

	/**
	* Get the month of this datetime.
	*/
	public EMonth GetMonth()
	{
		return view_as<EMonth>(this.Month);
	}

	/**
	* Get the day of this datetime.
	*/
	public EDay GetDay()
	{
		return view_as<EDay>(this.Day);
	}

	/**
	* Convert the Unix-Epoch time to human-readable date with the given format
	*
	* @param output		Output buffer
	* @param maxsize	Length of the buffer
	* @param format		For more formats, check http://cplusplus.com/reference/ctime/strftime/
	*/
	public void ToString(char[] output, int maxsize, const char[] format = "%Y-%m-%d %H:%M:%S")
	{
		FormatTime(output, maxsize, format, this.Unix);
	}

	/**
	* Checks whether this date is valid or not.
	*
	* @return			True if this DateTime is between year [1970; 2099] and has a valid month & day, false otherwise.
	*/
	public bool IsValid()
	{
		if(this.Year < 1970 || this.Year > 2099)
			return false;

		if(this.Month < 1 || this.Month > 12)
			return false;
		
		if(this.Day < 1 || this.Day > this.DaysInMonth)
			return false;

		if(this.Hour > 24 || this.Hour < 0)
			return false;
		
		if(this.Minute > 59 || this.Minute < 0)
			return false;
		
		if(this.Second > 59 || this.Second < 0)
			return false;

		return true;
	}

	/**
	* Checks whether this date is older than the given one.
	*
	* @param dateTime	DateTime you want to check.
	* @return			True if this DateTime is older than the given one, false otherwise.
	*/
	public bool IsOlder(DateTime dateTime)
	{
		return this.Unix < dateTime.Unix;
	}

	/**
	* Checks whether this date has already elapsed or not.
	*
	* @return			True if this DateTime has already elapsed, false otherwise.
	*/
	public bool HasElapsed()
	{
		return this.IsOlder(new DateTime(DateTime_Now));
	}

	/**
	* Checks whether this year is a leap year or not.
	*
	* @return			True if the year of this datetime is a leap year or not.
	*/
	public static bool IsYearLeap(int year)
	{
		return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
	}

	/**
	* Returns the amount of days in the given month.
	*
	* @return			Amount of days in the given month.
	*/
	public static int GetDaysInMonth(int year, EMonth month)
	{
		int daysInMonths[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
		if(DateTime.IsYearLeap(year))
			daysInMonths[month] = 29;
			
		return daysInMonths[month - 1];
	}

	/**
	* Get current DateTime.
	*
	* @return			DateTime with the current time.
	*/
	public static DateTime Now()
	{
		return new DateTime(DateTime_Now);
	}

	/**
	* Converts the string representation of a date and time to its DateTime equivalent.
	*
	* @param input string input
	*
	* @return			DateTime equivalent of given input.
	*/
	public static DateTime Parse(const char[] input)
	{
		//	 [0]	 [1]
		//2021-07-17 13:03:18
		char parts[2][12];
		int year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0;

		bool flag;
		if(ExplodeString(input, " ", parts, sizeof(parts), sizeof(parts[])) == 2)
		{
			flag = StrContains(parts[0], "-") != -1;

			char date[3][5];
			ExplodeString(parts[0], flag ? "-" : "/", date, sizeof(date), sizeof(date[]));
			year = StringToInt(date[0]); month = StringToInt(date[1]); day = StringToInt(date[2]);

			char timeStamp[3][3];
			ExplodeString(parts[1], ":", timeStamp, sizeof(timeStamp), sizeof(timeStamp[]));
			hour = StringToInt(timeStamp[0]); minute = StringToInt(timeStamp[1]); second = StringToInt(timeStamp[2]);
		} else {
			flag = StrContains(parts[0], "-") != -1;

			char date[3][5];
			ExplodeString(parts[0], flag ? "-" : "/", date, sizeof(date), sizeof(date[]));
			year = StringToInt(date[0]); month = StringToInt(date[1]); day = StringToInt(date[2]);
		}

		//https://www.oryx-embedded.com/doc/date__time_8c_source.html#l00258
		int stamp = 0;
		stamp = (365 * year) + (year / 4) - (year / 100) + (year / 400);
		stamp += (30 * month) + (3 * (month + 1) / 5) + day;
		stamp -= 719561;
		stamp *= SecondsPerDay;
		stamp += (SecondsPerHour * hour) + (SecondsPerMinute * minute) + second;
		return new DateTime(stamp);
	}

	/**
	* Converts the specified string representation of a date and time to its DateTime equivalent and returns a value that indicates whether the conversion succeeded.
	*
	* @param input string input
	*
	* @return 			DateTime equivalent of given input.
	*/
	public static bool TryParse(const char[] input, DateTime& out = view_as<DateTime>(0))
	{
		int length = strlen(input);
		if(length < 8 || length > DATE_LENGTH)
			return false;

		bool perFlag = StrContains(input, "/") != -1, hyphenFlag = StrContains(input, "-") != -1;
		if(!perFlag && !hyphenFlag)
			return false;

		DateTime temp = DateTime.Parse(input);
		if(!temp.IsValid())
			return false;

		out = temp;
		return true;
	}

	/**
	* Compare two datetimes.
	*
	* @param left		DateTime you want to compare.
	* @param right		DateTime you want to compare.
	* @return			0 if they're equal, -1 if the left is older, 1 if the right is older.
	*/
	public static int Compare(DateTime left, DateTime right)
	{
		if(left.IsOlder(right)) return -1;
		else if(right.IsOlder(left)) return 1;
		return 0;
	}

	/**
	* Subtract two DateTime from eachother.
	*
	* @param left		The first DateTime you want to subtract.
	* @param right		The second DateTime you want to subtract.
	* @return			a new DateTime.
	*/
	public static DateTime Subtract(DateTime left, DateTime right)
	{
		if(left.Unix >= right.Unix) return new DateTime(left.Unix - right.Unix);
		return new DateTime(right.Unix - left.Unix);
	}

	/**
	* Subtract a TimeSpan from a DateTime
	*
	* @param dt			DateTime you want to subtract from.
	* @param ts			TimeSpan you want to subtract.
	* @return			a new DateTime.
	*/
	public static DateTime SubtractTimeSpan(DateTime dt, TimeSpan ts)
	{
		return new DateTime(dt.Unix - ts.TotalSeconds);
	}

	/**
	* Add two DateTime to eachother.
	*
	* @param left		The first DateTime you want to add.
	* @param right		The second DateTime you want to add.
	* @return			a new DateTime.
	*/
	public static DateTime Add(DateTime left, DateTime right)
	{
		int diff = DateTime.Subtract(left, right).Unix;
		if(left.IsOlder(right)) return new DateTime(left.Unix + diff);
		return new DateTime(right.Unix + diff);
	}

	/**
	* Add a TimeSpan from a DateTime
	*
	* @param dt			DateTime you want to add to.
	* @param ts			TimeSpan you want to add.
	* @return			a new DateTime.
	*/
	public static DateTime AddTimeSpan(DateTime dt, TimeSpan ts)
	{
		return new DateTime(dt.Unix + ts.TotalSeconds);
	}
}

stock DateTime operator+(DateTime oper1, DateTime oper2)
{
	return DateTime.Add(oper1, oper2);
}

stock DateTime operator+(DateTime oper1, int oper2)
{
	return new DateTime(oper1.Unix + oper2);
}

stock DateTime operator+(DateTime oper1, TimeSpan oper2)
{
	return DateTime.AddTimeSpan(oper1, oper2);
}

stock DateTime operator-(DateTime oper1, DateTime oper2)
{
	return DateTime.Subtract(oper1, oper2);
}

stock DateTime operator-(DateTime oper1, int oper2)
{
	return new DateTime(oper1.Unix - oper2);
}

stock DateTime operator-(DateTime oper1, TimeSpan oper2)
{
	return DateTime.SubtractTimeSpan(oper1, oper2);
}

stock bool operator<(DateTime oper1, DateTime oper2)
{
	return oper1.Unix < oper2.Unix;
}

stock bool operator>(DateTime oper1, DateTime oper2)
{
	return oper1.Unix > oper2.Unix;
}

stock bool operator<=(DateTime oper1, DateTime oper2)
{
	return oper1.Unix <= oper2.Unix;
}

stock bool operator>=(DateTime oper1, DateTime oper2)
{
	return oper1.Unix >= oper2.Unix;
}

stock bool operator==(DateTime oper1, DateTime oper2)
{
	return oper1.Unix == oper2.Unix;
}

stock bool operator!=(DateTime oper1, DateTime oper2)
{
	return oper1.Unix != oper2.Unix;
}