# This code reproduces Figures 2 and S1 from Kass et al. 2024
# (https://doi.org/10.1111/ecog.07346). The final versions for the manuscript were
# edited in Adobe Illustrator.

library(ggplot2)

# Fig 2----
# Edits to text, resizing, and other edits were made in Adobe Illustrator
dend <- sdmverse::prep_table(where = "online") |>
  dplyr::filter(name != "rgbif",
                name != "ibis.iSDM",
                name != "dismo") |>
  dplyr::select(-mod_mechanistic,
                -mod_multispecies)

pal <- RColorBrewer::brewer.pal(n = 5,
                                name = "Dark2")

clust <- sdmverse::plot_dendrogram(dend,
                                   k = 5,
                                   cex = 1,
                                   diff_method = "binary",
                                   k_colors = pal,
                                   horiz = TRUE,
                                   main = "",
                                   return_clust = TRUE)

pkg_order <- rev(clust$labels[clust$order])

pkg_cols <- pkg_order

names(pkg_cols) <- pkg_order

pkg_cols[1:21] <- pal[5]
pkg_cols[22:26] <- pal[4]
pkg_cols[27:30] <- pal[3]
pkg_cols[31] <- pal[2]
pkg_cols[32:33] <- pal[1]

## Fig 2A----
pdf("output/fig2A.pdf",
    height = 7,
    width = 16)

sdmverse::plot_table(dend,
                     pkg_order = pkg_order,
                     pkg_cols = pkg_cols,
                     remove_empty_cats = TRUE)

dev.off()

## Fig 2B----
pdf("output/fig2B.pdf",
    height = 5,
    width = 9.7)

sdmverse::plot_dendrogram(dend,
                          k = 5,
                          cex = 0.7,
                          diff_method = "binary",
                          k_colors = pal,
                          horiz = TRUE,
                          main = "")

dev.off()

# FIG S1----
# Additions of text for package names and other edits were made in Adobe
# Illustrator
data <- read.csv("data/ms_figs/vignette_info.csv") |>
  tidyr::pivot_longer(cols = c(deficient, bronze, silver, gold),
                      names_to = "rating",
                      values_to = "value") |>
  dplyr::filter(standards != "Metadata") |>
  dplyr::mutate(rating = factor(rating,
                                levels = c("deficient", "bronze", "silver", "gold")),
                standards = factor(standards)) |>
  dplyr::rowwise() |>
  dplyr::mutate(value = ifelse(value != "",
                               paste(value, rating, collapse = "_"),
                               value)) |>
  dplyr::mutate(value = factor(value,
                               levels = c("",
                                          "X deficient",
                                          "X bronze",
                                          "X silver",
                                          "X gold")))

standard_cols <- c("white",
                   "black",
                   "#cd7f32",
                   "#C0C0C0",
                   "#FFD700")

pdf("output/figS1.pdf")

g1 <- ggplot(data = data |> dplyr::filter(vignettes == "Climate Change"),
             aes(x = rating, y = standards, fill = value)) +
  geom_tile() +
  scale_fill_manual(values = standard_cols) +
  scale_y_discrete(limits = rev(levels(data$standards))) +
  coord_equal() +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1,
                                   hjust = 1),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14),
        strip.text.x = element_text(size = 14),
        legend.position = "none") +
  facet_wrap(vars(vignettes))

g2 <- ggplot(data = data |> dplyr::filter(vignettes == "Invasive Species"),
             aes(x = rating, y = standards, fill = value)) +
  geom_tile() +
  scale_fill_manual(values = standard_cols) +
  scale_y_discrete(limits = rev(levels(data$standards))) +
  coord_equal() +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1,
                                   hjust = 1),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14),
        strip.text.x = element_text(size = 14),
        legend.position = "none") +
  facet_wrap(vars(vignettes))

g3 <- ggplot(data |> dplyr::filter(vignettes == "Rare Species"),
             aes(x = rating, y = standards, fill = value)) +
  geom_tile() +
  scale_fill_manual(values = standard_cols) +
  scale_y_discrete(limits = rev(levels(data$standards))) +
  coord_equal() +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1,
                                   hjust = 1),
        axis.text = element_text(size = 14),
        axis.title = element_text(size = 14),
        strip.text.x = element_text(size = 14),
        legend.position = "none") +
  facet_wrap(vars(vignettes))

gridExtra::grid.arrange(g1, g2, g3, nrow = 1)

dev.off()
