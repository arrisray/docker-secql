CREATE TABLE `secdb`.`companies` (
      `id` INT NOT NULL,
      `cik` INT NOT NULL,
      `name` VARCHAR(45) NOT NULL DEFAULT '255',
      `symbol` VARCHAR(45) NOT NULL DEFAULT '5',
      PRIMARY KEY (`id`),
      UNIQUE INDEX `id_UNIQUE` (`id` ASC),
      UNIQUE INDEX `name_UNIQUE` (`name` ASC),
      UNIQUE INDEX `cik_UNIQUE` (`cik` ASC),
      UNIQUE INDEX `symbol_UNIQUE` (`symbol` ASC));
