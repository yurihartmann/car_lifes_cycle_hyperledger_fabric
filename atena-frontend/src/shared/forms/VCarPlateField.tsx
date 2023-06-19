import { useEffect, useState } from 'react';
import { TextField, TextFieldProps } from '@mui/material';
import { useField } from '@unform/core';


type VCarPlateFieldProps = TextFieldProps & {
    name: string;
}
export const VCarPlateField: React.FC<VCarPlateFieldProps> = ({ name, ...rest }) => {
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
        <TextField
            {...rest}

            error={!!error}
            helperText={error}
            defaultValue={defaultValue}

            value={value || ''}
            onChange={e => {
                let value = e.target.value.toUpperCase().replace('-', '').substr(0, 7);
                const letters = value.substr(0, 3).replace(/[^A-Z]/g, '');
                const numbers = value.substr(3).replace(/\D/g, '');

                value = letters + (numbers ? '-' + numbers : numbers);
                e.target.value = value;
                
                setValue(value);
                rest.onChange?.(e);
            }}
            onKeyDown={(e) => { error && clearError(); rest.onKeyDown?.(e); }}
        />
    );
};
