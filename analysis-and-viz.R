{
  library(tidyverse)
  library(googlesheets4)
  library(janitor)
  library(jastyle)
}

score_raw = read_sheet("https://docs.google.com/spreadsheets/d/1zr41tZnYjpYIjA3aUU0rx8gfFy9bJJYlEGj4SYyFxus/edit#gid=1262248633",
                        sheet = "2023 scores") %>% 
  select(-comments)
apple_raw = read_sheet("https://docs.google.com/spreadsheets/d/1zr41tZnYjpYIjA3aUU0rx8gfFy9bJJYlEGj4SYyFxus/edit#gid=1262248633",
                       sheet = "2023 apples")

score_raw %>% 
  filter(!is.na(taste)) %>% 
  ggplot(aes(x = appearance, y = taste, color = scorer)) +
  geom_point() +
  geom_smooth(se = F) +
  theme_ja()
score_raw %>% 
  filter(!is.na(taste)) %>% 
  ggplot(aes(x = taste)) +
  geom_bar(stat = "count") +
  facet_wrap(~type) +
  theme_ja()

apple_averages = score_raw %>% 
  filter(!is.na(taste)) %>% 
  group_by(type) %>% 
  summarize(mean_score = mean(taste),
            min_score = min(taste),
            max_score = max(taste)) %>% 
  ungroup() %>% 
  arrange(mean_score) %>% 
  #ggplot(aes(x = type, y = mean_score)) +
  ggplot(aes(x = reorder(type, desc(mean_score)), y = mean_score)) + 
  geom_point() +
  geom_errorbar(aes(ymin = min_score, ymax = max_score),
                width = 0) + 
  theme_ja() +
  labs(y = "taste score (min, mean, max)", 
       x = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
apple_averages

scorer_averages = score_raw %>% 
  filter(!is.na(taste)) %>% 
  group_by(scorer) %>% 
  summarize(mean_score = mean(taste),
            min_score = min(taste),
            max_score = max(taste)) %>% 
  ungroup() %>% 
  arrange(mean_score) %>% 
  #ggplot(aes(x = type, y = mean_score)) +
  ggplot(aes(x = reorder(scorer, desc(mean_score)), y = mean_score)) + 
  geom_point() +
  geom_errorbar(aes(ymin = min_score, ymax = max_score),
                width = 0) + 
  theme_ja() +
  labs(y = "taste score (min, mean, max)", 
       x = NULL) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
scorer_averages

qc = score_raw %>% 
  select(type, scorer, "Round 1" = taste, "Round 2" = taste_2) %>% 
  filter(!is.na(`Round 2`)) %>% 
  pivot_longer(`Round 1`:`Round 2`) %>% 
  ggplot(aes(x = name, y = value, color = scorer, group = scorer)) + 
  geom_point() +
  geom_line() +
  facet_wrap(~type) +
  theme_ja() +
  labs(x = NULL, y = "taste score",
       subtitle = "Quality control proved we do not have a huge amount of internal consistency on our scoring")
qc

score_raw %>% 
  select(type:taste) %>% 
  pivot_longer(appearance:taste) %>% 
  filter(name %in% c("appearance", "taste")) %>% 
  ggplot(aes(x = name, y = value, color = scorer, group = scorer)) + 
  geom_point() +
  geom_line() + 
  facet_wrap(~type) +
  theme_ja() +
  labs(x = NULL, y = "score")
