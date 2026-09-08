package com.yukimomo.practice.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.List;

@Data
public class PaperSaveAnswersDTO {

    @NotEmpty
    @Valid
    private List<Item> answers;

    @Data
    public static class Item {
        @NotNull
        private Long questionId;
        /** 选择题字母，如 A */
        private String userAnswer;
    }
}
