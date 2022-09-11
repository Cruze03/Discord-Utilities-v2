/* This file is a part of the Eternar SDK. */

#if defined _TimeSpan_included_
  #endinput
#endif
#define _TimeSpan_included_

stock const float flSecondsPerYear = 31556926.0;
stock const float flSecondsPerWeek = 604800.0;
stock const float flSecondsPerDay = 86400.0;
stock const float flSecondsPerHour = 3600.0;
stock const float flSecondsPerMinute = 60.0;

stock const int SecondsPerYear = 31556926;
stock const int SecondsPerWeek = 604800;
stock const int SecondsPerDay = 86400;
stock const int SecondsPerHour = 3600;
stock const int SecondsPerMinute = 60;

#define TIMESPAN_LENGTH 64

methodmap TimeSpan __nullable__
{
	public TimeSpan(int days = 0, int hours = 0, int minutes = 0, int seconds = 0)
	{
		int stamp = days * SecondsPerDay + hours * SecondsPerHour + minutes * SecondsPerMinute + seconds;
		return view_as<TimeSpan>(stamp);
	}

	property int Days
	{
		public get()
		{
			int seconds = view_as<int>(this);
			return seconds / SecondsPerDay;
		}
	}

	property int Hours
	{
		public get()
		{
			int seconds = view_as<int>(this);
			seconds -= this.Days * SecondsPerDay;
			return seconds / SecondsPerHour;
		}
	}

	property int Minutes
	{
		public get()
		{
			int seconds = view_as<int>(this);
			seconds -= this.Days * SecondsPerDay;
			seconds -= this.Hours * SecondsPerHour;
			return seconds / SecondsPerMinute;
		}
	}

	property int Seconds
	{
		public get()
		{
			int seconds = view_as<int>(this);
			seconds -= this.Days * SecondsPerDay;
			seconds -= this.Hours * SecondsPerHour;
			seconds -= this.Minutes * SecondsPerMinute;
			return seconds;
		}
	}

	property int TotalSeconds
	{
		public get() { return view_as<int>(this); }
	}

	property float TotalMinutes
	{
		public get() { return this.TotalSeconds / flSecondsPerMinute; }
	}

	property float TotalHours
	{
		public get() { return this.TotalSeconds / flSecondsPerHour; }
	}

	property float TotalDays
	{
		public get() { return this.TotalSeconds / flSecondsPerDay; }
	}

	/**
	* Convert this TimeSpan to string.
	*
	* @param output		Output buffer
	* @param maxsize	Length of the buffer
	* @param format		Available keywords: {Days} {Hours} {Minutes} {Seconds}
	*/
	public void ToString(char[] output, int maxsize, const char[] format = "{Days}:{Hours}:{Minutes}:{Seconds}")
	{
		Format(output, maxsize, format);

		char temp[TIMESPAN_LENGTH];
		bool negativeFlag = false;

		int days = this.Days;
		if(days < 0) { negativeFlag = true; days *= -1; }
		IntToString(days, temp, sizeof(temp));
		ReplaceString(output, maxsize, "{Days}", temp);

		int hours = this.Hours;
		if(hours < 0) { negativeFlag = true; hours *= -1; }
		if(hours < 10) Format(temp, sizeof(temp), "0%i", hours);
		else IntToString(hours, temp, sizeof(temp));
		ReplaceString(output, maxsize, "{Hours}", temp);

		int minutes = this.Minutes;
		if(minutes < 0) { negativeFlag = true; minutes *= -1; }
		if(minutes < 10) Format(temp, sizeof(temp), "0%i", minutes);
		else IntToString(minutes, temp, sizeof(temp));
		ReplaceString(output, maxsize, "{Minutes}", temp);

		int seconds = this.Seconds;
		if(seconds < 0) { negativeFlag = true; seconds *= -1; }
		if(seconds < 10) Format(temp, sizeof(temp), "0%i", seconds);
		else IntToString(seconds, temp, sizeof(temp));
		ReplaceString(output, maxsize, "{Seconds}", temp);

		if(negativeFlag)
			Format(output, maxsize, "-%s", output);
	}

	public static TimeSpan FromSeconds(int seconds)
	{
		return view_as<TimeSpan>(seconds);
	}

	public static TimeSpan FromMinutes(int minutes)
	{
		return TimeSpan.FromSeconds(minutes * SecondsPerMinute);
	}

	public static TimeSpan FromHours(int hours)
	{
		return TimeSpan.FromSeconds(hours * SecondsPerHour);
	}

	public static TimeSpan FromDays(int days)
	{
		return TimeSpan.FromSeconds(days * SecondsPerDay);
	}

	public TimeSpan AddSeconds(int seconds)
	{
		return TimeSpan.FromSeconds(this.TotalSeconds + seconds);
	}

	public TimeSpan AddMinutes(int minutes)
	{
		return this.AddSeconds(minutes * SecondsPerMinute);
	}

	public TimeSpan AddHours(int hours)
	{
		return this.AddSeconds(hours * SecondsPerHour);
	}

	public TimeSpan AddDays(int days)
	{
		return this.AddSeconds(days * SecondsPerDay);
	}

	/**
	* Returns a new TimeSpan whose value is the sum of the TimeSpans
	*
	* @param ts1		The first time interval to add.
	* @param ts2		The second time interval to add.
	* @return			A new TimeSpan that represents the sum of the two TimeSpan.
	*/
	public static TimeSpan Add(TimeSpan ts1, TimeSpan ts2)
	{
		return TimeSpan.FromSeconds(ts1.TotalSeconds + ts2.TotalSeconds);
	}

	/**
	* Returns a new TimeSpan whose value is the difference of the TimeSpans
	*
	* @param ts1		The first time interval to subtract.
	* @param ts2		The second time interval to subtract.
	* @return			A new TimeSpan that represents the difference of the two TimeSpan.
	*/
	public static TimeSpan Subtract(TimeSpan ts1, TimeSpan ts2)
	{
		return TimeSpan.FromSeconds(ts1.TotalSeconds - ts2.TotalSeconds);
	}

	/**
	* Compares two TimeSpan values and returns an integer that indicates whether the first value is shorter than, equal to, or longer than the second value.
	*
	* @param ts1		The first time interval to compare.
	* @param ts2		The second time interval to compare.
	* @return			-1 if ts1 is shorter than ts2, 0 if ts1 is equal to ts2, 1 if ts1 is longer than ts2.
	*/
	public static int Compare(TimeSpan ts1, TimeSpan ts2)
	{
		int left = ts1.TotalSeconds;
		int right = ts2.TotalSeconds;
		if(left == right) return 0;
		else if(left > right) return -1;
		return 1;
	}

	/**
	* Initializes a new TimeSpan whose value is set to zero.
	*
	* @return			A new TimeSpan.
	*/
	public static TimeSpan Zero()
	{
		return new TimeSpan(_, _, _, _);
	}
}

stock TimeSpan operator+(TimeSpan oper1, TimeSpan oper2)
{
	return TimeSpan.Add(oper1, oper2);
}

stock TimeSpan operator+(TimeSpan oper1, int oper2)
{
	return new TimeSpan(oper1.TotalSeconds + oper2);
}

stock TimeSpan operator-(TimeSpan oper1, TimeSpan oper2)
{
	return TimeSpan.Subtract(oper1, oper2);
}

stock TimeSpan operator-(TimeSpan oper1, int oper2)
{
	return new TimeSpan(oper1.TotalSeconds - oper2);
}

stock bool operator<(TimeSpan oper1, TimeSpan oper2)
{
	return oper1.TotalSeconds < oper2.TotalSeconds;
}

stock bool operator>(TimeSpan oper1, TimeSpan oper2)
{
	return oper1.TotalSeconds > oper2.TotalSeconds;
}

stock bool operator<=(TimeSpan oper1, TimeSpan oper2)
{
	return oper1.TotalSeconds <= oper2.TotalSeconds;
}

stock bool operator>=(TimeSpan oper1, TimeSpan oper2)
{
	return oper1.TotalSeconds >= oper2.TotalSeconds;
}

stock bool operator==(TimeSpan oper1, TimeSpan oper2)
{
	return oper1.TotalSeconds == oper2.TotalSeconds;
}

stock bool operator!=(TimeSpan oper1, TimeSpan oper2)
{
	return oper1.TotalSeconds != oper2.TotalSeconds;
}