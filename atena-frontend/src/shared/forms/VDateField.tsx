import { useEffect, useState } from 'react';
import { useField } from '@unform/core';
import { DateField, DateFieldProps } from '@mui/x-date-pickers/DateField';
import { LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';


type TVDateFieldProps = DateFieldProps<Date> & {
    name: string;
}
export const VDateField: React.FC<TVDateFieldProps> = ({ name, ...rest }) => {
    const { fieldName, registerField, defaultValue, error, clearError } = useField(name);

    const [value, setValue] = useState(defaultValue || '');


    useEffect(() => {
        registerField({
            name: fieldName,
            getValue: () => value,
            setValue: (_, newValue) => setValue(newValue),
        });
    }, [registerField, fieldName, value]);


    return (
        <LocalizationProvider dateAdapter={AdapterDayjs}>
            <DateField
                {...rest}

                helperText={error}
                defaultValue={defaultValue}
                format="DD/MM/YYYY"

                value={value || ''}
                onChange={newValue => {
                    setValue(newValue);
                    // rest.onChange?.(newValue);
                }}
                onKeyDown={(e) => { error && clearError(); rest.onKeyDown?.(e); }}
            />
        </LocalizationProvider>
    );
};
