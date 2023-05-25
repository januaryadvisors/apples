{
  library(tidyverse)
  library(googlesheets4)
  library(janitor)
  library(jastyle)
}

score_raw = read_sheet("https://docs.google.com/spreadsheets/d/1zr41tZnYjpYIjA3aUU0rx8gfFy9bJJYlEGj4SYyFxus/edit#gid=1262248633",
                        sheet = "2023 scores") %>% 
  select(-comments) %>% 
  rename(apple_type = type, `expected taste` = expectation,
        `name quality` = name)
apple_raw = read_sheet("https://docs.google.com/spreadsheets/d/1zr41tZnYjpYIjA3aUU0rx8gfFy9bJJYlEGj4SYyFxus/edit#gid=1262248633",
                       sheet = "2023 apples")

summary_scores = score_raw %>% 
  select(apple_type:taste) %>% 
  pivot_longer(appearance:taste, names_to = "metric") %>%
  group_by(apple_type, metric) %>% 
  summarize(mean = round(mean(value, na.rm = T), 2),
            min = min(value, na.rm = T),
            max = max(value, na.rm = T))
write_csv(summary_scores, here::here("data-clean", "summary_scores.csv"))

# are appearance and taste correlated?
score_raw %>% 
  filter(scorer != "Jessica") %>% 
  filter(!is.na(taste)) %>% 
  ggplot(aes(x = appearance, y = taste, color = scorer)) +
  geom_point() +
  geom_smooth(se = F) +
  theme_ja()

score_raw %>% 
  filter(scorer != "Jessica") %>% 
  filter(!is.na(taste)) %>% 
  ggplot(aes(x = `expected taste`, y = taste, color = scorer)) +
  geom_point() +
  xlim(0, 5) + 
  geom_abline(aes(intercept = 0, slope = 1),
              color = "gray", linetype = 2) +
  geom_smooth(se = F, method = "lm") +
  theme_ja()

# distribution of scores for each apple
score_raw %>% 
  filter(!is.na(taste)) %>% 
  ggplot(aes(x = taste)) +
  geom_bar(stat = "count") +
  facet_wrap(~apple_type) +
  theme_ja()

# which apples score highest?
# sort by mean or by range
summary_scores %>% 
  filter(metric == "taste") %>% 
  ggplot(aes(x = reorder(apple_type, desc(mean)), y = mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin = min, ymax = max),
                width = 0) + 
  theme_ja() +
  labs(y = "taste score (min, mean, max)", 
       x = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# which scorers score high/low?
score_raw %>% 
  filter(!is.na(taste)) %>% 
  group_by(scorer) %>% 
  summarize(mean_score = mean(taste),
            min_score = min(taste),
            max_score = max(taste)) %>% 
  ungroup() %>% 
  arrange(mean_score) %>% 
  #ggplot(aes(x = apple_type, y = mean_score)) +
  ggplot(aes(x = reorder(scorer, desc(mean_score)), y = mean_score)) + 
  geom_point() +
  geom_errorbar(aes(ymin = min_score, ymax = max_score),
                width = 0) + 
  theme_ja() +
  labs(y = "taste score (min, mean, max)", 
       x = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# was scoring consistent across multiple tastings?
score_raw %>% 
  select(apple_type, scorer, "Round 1" = taste, "Round 2" = taste_2) %>% 
  filter(!is.na(`Round 2`)) %>% 
  pivot_longer(`Round 1`:`Round 2`) %>% 
  ggplot(aes(x = name, y = value, color = scorer, group = scorer)) + 
  geom_point() +
  geom_line() +
  facet_wrap(~apple_type) +
  theme_ja() +
  labs(x = NULL, y = "taste score",
       subtitle = "Quality control proved we do not have a huge amount of internal consistency on our scoring")

# how does appearance relate to taste for each apple?
summary_scores %>% 
  filter(metric %in% c("expected taste", "taste")) %>% 
  ggplot(aes(x = metric, y = mean, group = apple_type)) + 
  geom_point() +
  geom_errorbar(aes(ymin = min, ymax = max),
                width = 0) + 
  geom_line() + 
  facet_wrap(~apple_type) +
  theme_ja() +
  labs(x = NULL, y = "score")

# what are our favorite and least favorite names?
summary_scores %>% 
  filter(metric == "name quality") %>% 
  ggplot(aes(x = reorder(apple_type, desc(mean)), y = mean)) + 
  geom_point() +
  geom_errorbar(aes(ymin = min, ymax = max),
                width = 0) + 
  theme_ja() +
  labs(y = "name score (min, mean, max)", 
       x = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
