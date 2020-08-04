
figure;
subplot(1,2,1);
plot(1:trials, working_mem, '-o');
set(gca, 'YTick', 1:20);
xlabel('Trial'); ylabel('Errors (Entries into already entered arm)');
ylim([-1 20]);
title('Working Memory Error')


subplot(1,2,2);
plot(1:trials, reference_mem, '-o');
set(gca, 'YTick', 1:20);
xlabel('Trial'); ylabel('Errors (Entries into non-baited arm)');
ylim([-1 20]);
title('Reference Memory Error');