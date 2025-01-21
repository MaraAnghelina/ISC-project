package com.ebanking.scheduler;

import org.quartz.*;
import org.quartz.impl.StdSchedulerFactory;
import java.util.Calendar;
import java.util.Date;

import com.ebanking.scheduler.jobs.LoanPaymentJob;

public class LoanScheduler {
    public static void scheduleLoanPayment(Date loanDate) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(loanDate);
        int dayOfMonth = cal.get(Calendar.DAY_OF_MONTH);

        try {
            JobDetail job = JobBuilder.newJob(LoanPaymentJob.class)
                                      .withIdentity("loanPaymentJob")
                                      .build();

            Trigger trigger = TriggerBuilder.newTrigger()
                                            .withIdentity("monthlyTrigger")
                                            .withSchedule(CronScheduleBuilder.monthlyOnDayAndHourAndMinute(dayOfMonth, 0, 0))
                                            .build();

            Scheduler scheduler = new StdSchedulerFactory().getScheduler();
            scheduler.start();
            scheduler.scheduleJob(job, trigger);
        } catch (SchedulerException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        // Example date of loan. Replace with the actual loan date in real usage
        Date loanDate = new Date(); // or new SimpleDateFormat("yyyy-MM-dd").parse("2023-05-19");
        scheduleLoanPayment(loanDate);
    }
}